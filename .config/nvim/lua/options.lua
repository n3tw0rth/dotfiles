require "nvchad.options"

vim.opt.relativenumber = true
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25-Cursor,r-cr-o:hor20"
vim.opt.list = false

vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#9AA6B2", bold = false })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#9AA6B2", bold = false })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "white", bold = false })
