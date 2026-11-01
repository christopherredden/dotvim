-- Solution discovery for roslyn.nvim in large repositories.
local M = {}

-- A cached solution list older than this is used as-is but refreshed in the background.
local SOLUTION_LIST_TTL = 60

local cache_path = vim.fs.joinpath(vim.fn.stdpath("cache"), "roslyn_targets.json")

local function realpath(path)
    return vim.uv.fs_realpath(path) or vim.fs.normalize(path)
end

local function mtime(path)
    local stat = vim.uv.fs_stat(path)
    return stat and stat.mtime.sec or 0
end

local function join(dir, rel)
    rel = rel:gsub("\\", "/")
    if rel:sub(1, 1) ~= "/" then
        rel = dir .. "/" .. rel
    end
    return vim.fn.simplify(rel)
end

---@type table<string, { time: integer, slns: string[] }>
local solution_lists = (function()
    local ok, lines = pcall(vim.fn.readfile, cache_path)
    if not ok then
        return {}
    end
    local ok_json, data = pcall(vim.json.decode, table.concat(lines, "\n"))
    return ok_json and type(data) == "table" and data or {}
end)()

local function save_solution_lists()
    vim.fn.mkdir(vim.fs.dirname(cache_path), "p")
    pcall(vim.fn.writefile, { vim.json.encode(solution_lists) }, cache_path)
end

-- rg -g globs override .gitignore, re-including generated solutions ignored by file pattern
-- (e.g. **/*.gen.sln). Ignored directories such as artifacts/ are still skipped entirely.
local function list_command(root)
    return { "rg", "--files", "--hidden", "-g", "*.sln", "-g", "*.slnx", "-g", "*.slnf", "-g", "!.git", root }
end

local function store_list_output(root, stdout)
    local slns = vim.split(vim.trim(stdout or ""), "\n", { trimempty = true })
    table.sort(slns)
    solution_lists[root] = { time = os.time(), slns = slns }
    save_solution_lists()
    return slns
end

local pending_refresh = {} ---@type table<string, fun(slns: string[])[]>

--- Re-lists solutions for `root` without blocking; `callback` (optional) receives the new list.
---@param root string
---@param callback? fun(slns: string[])
function M.refresh_solutions(root, callback)
    if pending_refresh[root] then
        table.insert(pending_refresh[root], callback)
        return
    end
    pending_refresh[root] = { callback }
    vim.system(list_command(root), { text = true }, function(res)
        vim.schedule(function()
            local slns = res.code == 0 and store_list_output(root, res.stdout) or {}
            local callbacks = pending_refresh[root]
            pending_refresh[root] = nil
            for _, cb in pairs(callbacks) do
                cb(slns)
            end
        end)
    end)
end

--- Every .sln/.slnx/.slnf under `root`, including git-ignored generated ones.
--- Returns the cached list immediately when there is one; only blocks on the very first call.
---@param root string
---@return string[]
function M.list_solutions(root)
    local cached = solution_lists[root]
    if cached then
        if os.time() - cached.time >= SOLUTION_LIST_TTL then
            M.refresh_solutions(root)
        end
        return cached.slns
    end
    local res = vim.system(list_command(root), { text = true }):wait()
    return res.code == 0 and store_list_output(root, res.stdout) or {}
end

--- Async variant of `list_solutions`.
---@param root string
---@param callback fun(slns: string[])
function M.list_solutions_async(root, callback)
    local cached = solution_lists[root]
    if cached then
        if os.time() - cached.time >= SOLUTION_LIST_TTL then
            M.refresh_solutions(root)
        end
        callback(cached.slns)
    else
        M.refresh_solutions(root, callback)
    end
end

local projects_cache = {} ---@type table<string, { mtime: integer, projects: string[] }>

--- Absolute .csproj paths listed in a .sln or .slnx.
---@param sln string
---@return string[]
function M.solution_projects(sln)
    local cached = projects_cache[sln]
    if cached and cached.mtime == mtime(sln) then
        return cached.projects
    end
    local projects = {}
    local dir = vim.fs.dirname(sln)
    local ok, lines = pcall(vim.fn.readfile, sln)
    if ok then
        local pattern = sln:match("%.slnx$") and 'Path="([^"]+%.csproj)"' or '^Project%(.-%)%s*=%s*".-",%s*"([^"]+%.csproj)"'
        for _, line in ipairs(lines) do
            local rel = line:match(pattern)
            if rel then
                projects[#projects + 1] = join(dir, rel)
            end
        end
    end
    projects_cache[sln] = { mtime = mtime(sln), projects = projects }
    return projects
end

--- True if the project has an explicit <Compile Include> resolving to `file`.
local function project_compiles(csproj, file, basename)
    local ok, lines = pcall(vim.fn.readfile, csproj)
    if not ok then
        return false
    end
    local dir = vim.fs.dirname(csproj)
    for _, line in ipairs(lines) do
        local include = line:match('<Compile%s+Include="([^"]+)"')
        if include and include:find(basename, 1, true) and join(dir, include) == file then
            return true
        end
    end
    return false
end

--- Solutions among `slns` whose projects explicitly compile `file`, smallest first.
--- Projects that rely on SDK globbing are not detected.
---@param file string
---@param slns string[]
---@param callback fun(found: string[])
function M.solutions_containing(file, slns, callback)
    file = realpath(file)
    local basename = vim.fs.basename(file)

    local project_to_slns = {} ---@type table<string, string[]>
    for _, sln in ipairs(slns) do
        if not sln:match("%.slnf$") then
            for _, proj in ipairs(M.solution_projects(sln)) do
                project_to_slns[proj] = project_to_slns[proj] or {}
                table.insert(project_to_slns[proj], sln)
            end
        end
    end

    local existing = vim.tbl_filter(function(p) return vim.uv.fs_stat(p) ~= nil end, vim.tbl_keys(project_to_slns))
    if #existing == 0 then
        callback({})
        return
    end

    -- A fixed-string rg over the project files narrows the candidates before any XML is read.
    local cmd = { "rg", "--files-with-matches", "--fixed-strings", "--no-messages", "--", basename }
    vim.list_extend(cmd, existing)
    vim.system(cmd, { text = true }, function(res)
        vim.schedule(function()
            local found, seen = {}, {}
            for _, proj in ipairs(vim.split(res.stdout or "", "\n", { trimempty = true })) do
                if project_compiles(proj, file, basename) then
                    for _, sln in ipairs(project_to_slns[proj] or {}) do
                        if not seen[sln] then
                            seen[sln] = true
                            found[#found + 1] = sln
                        end
                    end
                end
            end
            table.sort(found, function(a, b)
                return #M.solution_projects(a) < #M.solution_projects(b)
            end)
            callback(found)
        end)
    end)
end

--- Calls `callback` with the solution to load for `bufnr`: a running client's solution if it
--- compiles the file, otherwise the smallest solution that does, otherwise nil.
---@param bufnr integer
---@param callback fun(sln: string?)
function M.solution_for_buffer(bufnr, callback)
    local file = vim.api.nvim_buf_get_name(bufnr)
    local root = file ~= "" and vim.fs.root(file, ".git")
    if not root then
        callback(nil)
        return
    end

    local store = require("roslyn.store")
    local running = {}
    for _, client in ipairs(vim.lsp.get_clients({ name = "roslyn" })) do
        running[#running + 1] = store.get(client.id)
    end

    local function search_all()
        M.list_solutions_async(root, function(slns)
            M.solutions_containing(file, slns, function(found)
                callback(found[1])
            end)
        end)
    end

    if #running == 0 then
        search_all()
        return
    end
    M.solutions_containing(file, running, function(found)
        if found[1] then
            callback(found[1])
        else
            search_all()
        end
    end)
end

--- `:Roslyn target` lists solutions through roslyn.nvim's broad search, which walks every
--- directory in Lua; replace it with the cached rg-based listing.
function M.patch_broad_search()
    require("roslyn.sln.utils").find_solutions_broad = function(bufnr)
        local root = vim.fs.root(bufnr, ".git") or vim.uv.cwd()
        return M.list_solutions(root)
    end
end

local jump_client ---@type vim.lsp.Client?

--- Records which Roslyn client an LSP jump comes from while `show_document` opens the target.
--- Roslyn resolves metadata/PDB source documents only in the client that returned them.
function M.track_lsp_jumps()
    local show_document = vim.lsp.util.show_document
    vim.lsp.util.show_document = function(...)
        jump_client = vim.lsp.get_clients({ name = "roslyn", bufnr = vim.api.nvim_get_current_buf() })[1]
        local ok, result = pcall(show_document, ...)
        jump_client = nil
        if not ok then
            error(result, 0)
        end
        return result
    end
end

local chosen = {} ---@type table<string, string>

--- root_dir for the roslyn client config. Resolves asynchronously, so opening a file never blocks.
function M.root_dir(bufnr, on_dir)
    if jump_client and jump_client.config.root_dir then
        on_dir(jump_client.config.root_dir)
        return
    end

    M.solution_for_buffer(bufnr, function(sln)
        if not vim.api.nvim_buf_is_valid(bufnr) then
            return
        end
        if sln then
            chosen[vim.fs.dirname(sln)] = sln
            on_dir(vim.fs.dirname(sln))
            return
        end

        -- No solution compiles the file: fall back to roslyn.nvim's upward search, which also
        -- reuses the currently selected solution.
        local config = require("roslyn.config").get()
        local saved = config.broad_search
        config.broad_search = false
        local root = require("roslyn.sln.utils").root_dir(bufnr)
        config.broad_search = saved
        if root then
            on_dir(root)
        end
    end)
end

--- choose_target for roslyn.nvim: picks the solution `root_dir` selected for that directory.
---@param targets string[]
---@return string?
function M.choose_target(targets)
    for _, target in ipairs(targets) do
        if chosen[vim.fs.dirname(target)] == target then
            return target
        end
    end
end

return M
