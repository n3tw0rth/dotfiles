local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = vim.lsp.config
local servers = { "html", "cssls", "phpactor", "ts_ls", "pyright", "clangd", "terraformls", "gopls", "astro", "asm_ls",
  "tailwindcss", "yamlls", "marksman" }

vim.lsp.enable('marksman')
vim.lsp.enable('rust_analyzer')

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp] = {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

--rust
lspconfig.rust_analyzer = {
  on_attach = on_attach,
  on_init = on_init,
  filetypes = { "rust" },
  settings = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      cargo = {
        allFeatures = true,
        buildScripts = {
          enable = true,
        },
      },
      procMacro = {
        enable = true,
      },
    },
  },
}

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = function()
    vim.lsp.buf.format()
  end,
})
