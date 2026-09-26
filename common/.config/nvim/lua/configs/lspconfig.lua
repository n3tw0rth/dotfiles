local lspconfig = vim.lsp.config
local servers = {
  html = {},
  cssls = {},
  phpactor = {},
  ts_ls = {},
  pyright = {},
  clangd = {},
  terraformls = {},
  gopls = {},
  astro = {},
  asm_ls = {},
  tailwindcss = {},
  yamlls = {},
  marksman = {},
  rust_analyzer = {
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
  },
  harper_ls = {}
}

for name, opts in pairs(servers) do
  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = function()
    vim.lsp.buf.format()
  end,
})
