-- Bootstrap Packer
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

	-- My plugins here
	-- Color scheme
	use 'navarasu/onedark.nvim';

	-- Telescope fuzzy finder
	use "nvim-telescope/telescope.nvim";
	use "nvim-telescope/telescope-fzf-native.nvim";
	use "nvim-lua/plenary.nvim";
	--"nvim-telescope/telescope-ui-select.nvim";

	-- Configs for NeoVim LSP client
	use "neovim/nvim-lspconfig";

	-- Show LSP status messages
	--use "nvim-lua/lsp-status.nvim";

	-- Status line in Lua
	use "nvim-lualine/lualine.nvim";

    -- Motion plugin
    use "ggandor/leap.nvim";

	-- Notification framework
	--use "rcarriga/nvim-notify";

	-- LSP-based Completion plugin
	--use "hrsh7th/nvim-cmp";
	--use "hrsh7th/cmp-nvim-lsp";

	-- nvim Tree for directory browsing
	--"nvim-tree/nvim-web-devicons";
	--"nvim-tree/nvim-tree.lua";

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- Enable OneDark colour scheme
require('onedark').load()

--vim.lsp.set_log_level("debug")

-- autocomplete config
--[[local cmp = require 'cmp'
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
}--]]

local lualine = require('lualine')
lualine.setup{}

-- Set up Leap
require('leap').add_default_mappings()

-- omnisharp lsp config
--[[
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
}--]]

-- Nvim Tree config
--require("nvim-tree").setup()

local set = vim.opt

-- Set the behavior of tab
set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4
set.expandtab = true
set.smartindent = true

-- Enable line numbers
set.number = true
