-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  -- Core LSP client
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Optional: Mason to auto-install servers
      { "williamboman/mason.nvim", config = true },
      { "williamboman/mason-lspconfig.nvim" },
      -- Optional: nvim-cmp capability injection
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      --------------------------------------------------------------------
      -- 0. Helpers ------------------------------------------------------
      local lsp = require("lspconfig")

      -- nvim-cmp capabilities (safe to remove if you don’t use cmp)
      local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = ok and cmp_lsp.default_capabilities()
                          or vim.lsp.protocol.make_client_capabilities()

      -- on_attach: keymaps only active when LSP attaches
      local function on_attach(_, bufnr)
        local nmap = function(keys, func, desc)
          vim.keymap.set("n", keys, func,
            { buffer = bufnr, silent = true, desc = "LSP: " .. desc })
        end
        nmap("gd", vim.lsp.buf.definition, "Go to definition")
        nmap("K",  vim.lsp.buf.hover,      "Hover")
        nmap("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        nmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
        nmap("<leader>f",  function() vim.lsp.buf.format { async = true } end,
             "Format buffer")
      end

      --------------------------------------------------------------------
      -- 1. Ensure zls installed (Mason) ---------------------------------
      require("mason-lspconfig").setup {
        ensure_installed = { "zls" },
      }

      --------------------------------------------------------------------
      -- 2. Default handler (called for every LSP Mason knows) -----------
      require("mason-lspconfig").setup_handlers {
        function(server_name)
          lsp[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
          }
        end,
      }

      --------------------------------------------------------------------
      -- 3. Extra per-server tweaks (optional) ---------------------------
      -- Example: explicit path to zls binary
      -- lsp.zls.setup {
      --   cmd = { "/absolute/path/to/zls" },
      --   capabilities = capabilities,
      --   on_attach = on_attach,
      -- }
    end,
  },
}

