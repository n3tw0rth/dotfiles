vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "
vim.o.swapfile = false

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require "setup"

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)


vim.api.nvim_create_autocmd("FileType", {
  pattern = "terraform",
  callback = function()
    vim.opt_local.commentstring = "# %s"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascriptreact,typescript",
  callback = function()
    vim.opt_local.commentstring = "// %s"
  end,
})

-- change color for all the nvim-tree icons
local icon_color = "#9AA6B2" -- Change this to whatever color you want

vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = icon_color })
vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderIcon", { fg = icon_color })
vim.api.nvim_set_hl(0, "NvimTreeClosedFolderIcon", { fg = icon_color })
vim.api.nvim_set_hl(0, "NvimTreeFileIcon", { fg = icon_color })
vim.api.nvim_set_hl(0, "NvimTreeSpecialFile", { fg = "#D3D3D3", bold = false, italic = false })

for _, group in ipairs(vim.fn.getcompletion("DevIcon", "highlight")) do
  vim.api.nvim_set_hl(0, group, { fg = icon_color })
end
