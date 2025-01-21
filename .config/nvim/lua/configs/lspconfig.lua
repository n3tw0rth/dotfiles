local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local servers = { "html", "cssls", "phpactor" }

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

--rust
lspconfig.rust_analyzer.setup {
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

-- typescript
lspconfig.ts_ls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}

--python
lspconfig.pyright.setup {
  on_attach = on_attach,
  on_init = on_init,
  filetypes = { "python" },
}

--tailwindcss
lspconfig.tailwindcss.setup {
  on_attach = on_attach,
  on_init = on_init,
}


--clangd
require('lspconfig').clangd.setup {
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto", "hpp" },
}

require("lspconfig").terraformls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities
}
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

--gopls
lspconfig.gopls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities
}

--astrols
lspconfig.astro.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities
}

--yamlls
require("lspconfig").yamlls.setup {
  -- settings = {
  --   yaml = {
  --     -- schemas = {
  --     --   -- kubernetes = "*.{yml,yaml}",
  --     --   -- add istio
  --     --   -- ["https://github.com/snowdrop/istio-java-api/blob/master/istio-model/src/main/resources/schema/istio-schema.json"]
  --     --   ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
  --     --   ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
  --     --   ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
  --     --   ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
  --     -- },
  --
  --   }
  -- }
}
