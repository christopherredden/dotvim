-- Make sure to setup `mapleader` and `maplocalleader` before
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.winborder = "rounded"

local settings = vim.opt
settings.tabstop = 4
settings.shiftwidth = 4
settings.softtabstop = 4
settings.expandtab = true
settings.smartindent = true
settings.number = true
settings.relativenumber = true
settings.swapfile = false
settings.undofile = true
settings.signcolumn = "yes"

vim.pack.add({
  "https://github.com/echasnovski/mini.nvim",
  "https://github.com/echasnovski/mini.icons",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/folke/persistence.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/folke/tokyonight.nvim",
  "https://github.com/ibhagwan/fzf-lua",
  "https://github.com/ggandor/leap.nvim",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/Saghen/blink.cmp",
})

require('leap').set_default_mappings()

require('blink.cmp').setup({
    fuzzy = {
        implementation = "lua",
    },
    signature = {
        enabled = true,
    },
    completion = {
        list = {
            max_items = 200,
            selection = {
                preselect = true,
                auto_insert = true,
            },
        },
    },
})

require('fzf-lua').setup({ winopts={fullscreen=true} })

require("oil").setup()
require("oil").set_columns({ "icon", "size" })

require('lspconfig').lua_ls.setup({
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using
        version = 'LuaJIT',
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = { vim.env.VIMRUNTIME }
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' }
      }
    }
  }
})

require('which-key').setup({
    preset = "helix",
})

vim.lsp.enable('lua_ls')
vim.lsp.enable('omnisharp')
vim.lsp.enable('zls')
vim.lsp.enable('clangd')

require("nvim-treesitter.configs").setup({
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      "bash",
      "c",
      "c_sharp",
      "cpp",
      "diff",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "printf",
      "python",
      "query",
      "regex",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
      "zig",
  },
})

--vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" })
vim.keymap.set("n", "<leader><leader>", "<Cmd>FzfLua global<CR>", { desc = "Global" })
vim.keymap.set("n", "<leader>ff", "<Cmd>FzfLua files<CR>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fgg", "<Cmd>FzfLua grep<CR>", { desc = "Grep" })
vim.keymap.set("n", "<leader>fgw", "<Cmd>FzfLua grep_cword<CR>", { desc = "Grep Word" })
vim.keymap.set("n", "<leader>fgl", "<Cmd>FzfLua live_grep<CR>", { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fb", "<Cmd>FzfLua buffers<CR>", { desc = "Buffers" })
vim.keymap.set("n", "gd", "<Cmd>FzfLua lsp_definitions<CR>", { desc = "Goto Definition" })
vim.keymap.set("n", "gD", "<Cmd>FzfLua lsp_declarations<CR>", { desc = "Goto Declaration" })
vim.keymap.set("n", "gr", "<Cmd>FzfLua lsp_references<CR>", { desc = "Goto References" })
vim.keymap.set("n", "gI", "<Cmd>FzfLua lsp_implementations<CR>", { desc = "Goto Implementations" })
vim.keymap.set("n", "gy", "<Cmd>FzfLua lsp_type_definitions<CR>", { desc = "Goto T[y]pe Definition" })
vim.keymap.set("n", "<leader>fss", "<Cmd>FzfLua lsp_workspace_symbols<CR>", { desc = "LSP Symbols" })
vim.keymap.set("n", "<leader>fsS", "<Cmd>FzfLua lsp_document_symbols<CR>", { desc = "LSP Document Symbols" })

vim.cmd[[colorscheme tokyonight-moon]]

if vim.fn.has('win32') then
  vim.o.shell = "powershell.exe"
end

if vim.g.neovide then
    vim.o.guifont = "Inconsolata Nerd Font Mono:h11"
    vim.g.neovide_scale_factor = 1.0
    local change_scale_factor = function(delta)
      vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
    end
    vim.keymap.set("n", "<C-=>", function()
      change_scale_factor(1.25)
    end)
    vim.keymap.set("n", "<C-->", function()
      change_scale_factor(1/1.25)
    end)
end


        --{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
--[[
-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" },

    -- Mini
    { 'echasnovski/mini.nvim', version = '*' },
    { 'echasnovski/mini.icons', version = '*' },

    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        opts = {
            servers = {
                clangd = {},
                zls = {},
                omnisharp = {},
            },
        },
    },

    -- Session management
    {
      "folke/persistence.nvim",
      event = "BufReadPre", -- this will only start session saving when an actual file was opened
      opts = {
        -- add any custom options here
      }
    },

    -- leap
    { 'ggandor/leap.nvim', lazy = false,
       config = function()
        require('leap').set_default_mappings()
       end,
    },

    -- which-key
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts_extend = { "spec" },
      opts = {
        preset = "helix",
        defaults = {},
        spec = {
          {
            mode = { "n", "v" },
            { "<leader><tab>", group = "tabs" },
            { "<leader>c", group = "code" },
            { "<leader>d", group = "debug" },
            { "<leader>dp", group = "profiler" },
            { "<leader>f", group = "file/find" },
            { "<leader>g", group = "git" },
            { "<leader>gh", group = "hunks" },
            { "<leader>q", group = "quit/session" },
            { "<leader>s", group = "search" },
            { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
            { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
            { "[", group = "prev" },
            { "]", group = "next" },
            { "g", group = "goto" },
            { "gs", group = "surround" },
            { "z", group = "fold" },
            {
              "<leader>b",
              group = "buffer",
              expand = function()
                return require("which-key.extras").expand.buf()
              end,
            },
            {
              "<leader>w",
              group = "windows",
              proxy = "<c-w>",
              expand = function()
                return require("which-key.extras").expand.win()
              end,
            },
            -- better descriptions
            { "gx", desc = "Open with system app" },
          },
        },
      },
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
         desc = "Buffer Keymaps (which-key)",
        },
        {
          "<c-w><space>",
          function()
            require("which-key").show({ keys = "<c-w>", loop = true })
          end,
          desc = "Window Hydra Mode (which-key)",
        },
      },
      config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        if not vim.tbl_isempty(opts.defaults) then
          LazyVim.warn("which-key: opts.defaults is deprecated. Please use opts.spec instead.")
          wk.register(opts.defaults)
        end
      end,
    },

    -- Tokyonight colorscheme
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },

    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      opts = {
        picker = {
          sources = {
            explorer = {
              focus = "input",
              auto_close = false,
            },
          },
        },
        explorer = {},

        dashboard = {
          enabled = true,
          sections = {
            { section = "header" },
            { section = "keys", gap = 0, padding = 1 },
            { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
            { 
              icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1, 
              action = function(opts)
                --vim.cmd('bdelete')
                vim.fn.chdir(opts)
                Snacks.explorer()
              end, 
            },
            { section = "startup" },
          },
        },
      },
      keys = {
        -- Top Pickers & Explorer
        { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
        { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
        { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
        -- find
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
        { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
        { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
        { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
        { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
        -- git
        { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
        { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
        { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
        { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
        { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
        { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
        { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
        -- Grep
        { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
        { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
        { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
        -- search
        { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
        { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
        { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
        { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
        { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
        { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
        { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
        { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
        { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
        { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
        { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
        { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
        { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
        { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
        { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
        { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
        { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
        { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
        { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
        -- LSP
        { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
        { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
        { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
        { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
        { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
        { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
        { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
        -- Scratch
        { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
        { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      },
    },

    {
      "nvim-treesitter/nvim-treesitter",
      version = false, -- last release is way too old and doesn't work on Windows
      build = ":TSUpdate",
      lazy = false,
      cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
      keys = {
        { "<c-space>", desc = "Increment Selection" },
        { "<bs>", desc = "Decrement Selection", mode = "x" },
      },
      opts_extend = { "ensure_installed" },
      opts = {
        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = {
          "bash",
          "c",
          "c_sharp",
          "cpp",
          "diff",
          "html",
          "javascript",
          "jsdoc",
          "json",
          "jsonc",
          "lua",
          "luadoc",
          "luap",
          "markdown",
          "markdown_inline",
          "printf",
          "python",
          "query",
          "regex",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "xml",
          "yaml",
          "zig",
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        textobjects = {
          move = {
            enable = true,
            goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
            goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
            goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
          },
        },
      },
      ---@param opts TSConfig
      config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
      end,
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "tokyonight-moon" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})--]]

