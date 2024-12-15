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

--
--
-- vim.filetype.add({
--   extension = {
--     fheaders = "feteched",
--   }
-- })
--
--
-- vim.api.nvim_create_autocmd('FileType', {
--   -- This handler will fire when the buffer's 'filetype' is "python"
--   pattern = 'feteched',
--   callback = function(args)
--     vim.lsp.start({
--       name     = 'useless',
--       cmd      = { "/home/byt3z/projects/useless-lsp/target/debug/useless-lsp" }, -- Replace with the actual path to the binary
--       root_dir = vim.fs.root(0, { '.git' }),
--     })
--   end,
-- })

require("lspconfig").terraformls.setup {}
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.tf", "*.tfvars" },
  callback = function()
    vim.lsp.buf.format()
  end,
})
