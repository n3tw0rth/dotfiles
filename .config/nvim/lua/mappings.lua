require "nvchad.mappings"


local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map({ "n", "v" }, "<leader>cc", [[:s/\v_(\w)/\U\1/g<CR>:s/\v(^\l)/\L\1/<CR>]], { desc = "snake_case to camelCase" })
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--
