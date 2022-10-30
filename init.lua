require "paq" 
{
    -- Let Paq manage itself
    "savq/paq-nvim";                  

    -- Color scheme
    "navarasu/onedark.nvim";

    -- Telescope fuzzy finder
    "nvim-telescope/telescope.nvim";
    "nvim-lua/plenary.nvim";
    "nvim-telescope/telescope-ui-select.nvim";

    -- Configs for NeoVim LSP client
    "neovim/nvim-lspconfig";

    -- Show LSP status messages
    "nvim-lua/lsp-status.nvim";

    -- Status line in Lua
    "nvim-lualine/lualine.nvim";

    -- Notification framework
    "rcarriga/nvim-notify";

    -- LSP-based Completion plugin
    "hrsh7th/nvim-cmp";
    "hrsh7th/cmp-nvim-lsp";
}

-- Enable OneDark colour scheme
require('onedark').load()

vim.lsp.set_log_level("debug")

-- autocomplete config
local cmp = require 'cmp'
cmp.setup 
{
  mapping = 
  {
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    })
  },
  sources = 
  {
    { name = 'nvim_lsp' },
  }
}

local lualine = require('lualine')
lualine.setup{}

-- omnisharp lsp config
require'lspconfig'.omnisharp.setup 
{
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    on_attach = function(client, bufnr)
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    end,
    cmd = { "dotnet", "/opt/omnisharp-roslyn/OmniSharp.dll", "--languageserver" , "--hostPID", tostring(pid) },
    root_dir = require('lspconfig').util.find_git_ancestor,
    --single_file_support = true,
}

-- rust_analyzer lsp config
require('lspconfig')['rust_analyzer'].setup
{
    on_attach = function(client, bufnr)
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    end,
    flags = lsp_flags,
    -- Server-specific settings...
    settings = {
      ["rust-analyzer"] = {}
    }
}


-- Telescope config
require("telescope").setup 
{
  extensions = 
  {
    ["ui-select"] = 
    {
      require("telescope.themes").get_dropdown 
      {
        -- even more opts
      }

      -- pseudo code / specification for writing custom displays, like the one
      -- for "codeactions"
      -- specific_opts = {
      --   [kind] = {
      --     make_indexed = function(items) -> indexed_items, width,
      --     make_displayer = function(widths) -> displayer
      --     make_display = function(displayer) -> function(e)
      --     make_ordinal = function(e) -> string
      --   },
      --   -- for example to disable the custom builtin "codeactions" display
      --      do the following
      --   codeactions = false,
      -- }
    }
  }
}
-- To get ui-select loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require("telescope").load_extension("ui-select")

local set = vim.opt

-- Set the behavior of tab
set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4
set.expandtab = true
set.smartindent = true

-- Enable line numbers
set.number = true
