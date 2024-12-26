require "nvchad.mappings"


local map = vim.keymap.set

-- General
map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader>gb", require("gitsigns").toggle_current_line_blame, { desc = "inline git blames" })
map("i", "jk", "<ESC>")

-- Replace
map({ "n", "v" }, "<leader>cc", [[:s/\v_(\w)/\U\1/g<CR>:s/\v(^\l)/\L\1/<CR>]], { desc = "snake_case to camelCase" })
map({ "n", "v" }, "<leader>ck", [[:s/\v-([a-z])/_\1/g<CR>]], { desc = "kebab-case to snake_case" })

-- telescope
map("n", "<leader>fr", require("telescope.builtin").resume, { desc = "resume the previous picker" })
map("n", "<leader>fgb", require("telescope.builtin").git_branches, { desc = "git branches" })
map("n", "<leader>fm", require("telescope.builtin").marks, { desc = "show marks" })
map("n", "<leader>fs", require("telescope.builtin").grep_string, { desc = "grep string under cursor" })
map(
  "n",
  "<leader>fw",
  ":lua require('telescope.builtin').live_grep({ additional_args = function() return { '--hidden' } end })<cr>",
  { silent = true, desc = "Find in Files" }
)

-- Oil
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
