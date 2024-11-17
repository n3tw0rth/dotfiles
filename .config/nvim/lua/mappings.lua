require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- commented this to enable the functionality to reapeat till using ;
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
