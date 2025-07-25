require "nvchad.mappings"


local map = vim.keymap.set

-- General
map("n", ";", ":", { desc = "CMD enter command mode" })
map("n", "<leader><leader>x", [[:%bdelete|edit #|normal`"<CR>]], { desc = "Close all buffers except current one" })
map("n", "<leader>gb", require("gitsigns").toggle_current_line_blame, { desc = "inline git blames" })

map("i", "jk", "<ESC>")


-- Replace
map({ "n", "v" }, "<leader>cc", [[:s/\v_(\w)/\U\1/g<CR>:s/\v(^\l)/\L\1/<CR>]], { desc = "snake_case to camelCase" })
map({ "n", "v" }, "<leader>ck", [[:s/\v-([a-z])/_\1/g<CR>]], { desc = "kebab-case to snake_case" })

-- telescope
map("n", "<leader>gG", require("telescope.builtin").git_branches, { desc = "Checkout git branch" })
map("n", "<leader>gs", require("telescope.builtin").git_status, { desc = "Open current modified files" })
map("n", "<leader>fr", require("telescope.builtin").resume, { desc = "Resume the previous picker" })
map("n", "<leader>fm", require("telescope.builtin").marks, { desc = "Show marks" })
map("n", "<leader>fs", require("telescope.builtin").grep_string, { desc = "Grep string under cursor" })
map("n", "<leader>fi", require("telescope.builtin").lsp_implementations, { desc = "Show implementations" })
map("n", '<leader>ze', require("telescope").load_extension("emoji").emoji , { desc = '[S]earch [E]moji' })
map(
  "n",
  "<leader>fw",
  ":lua require('telescope.builtin').live_grep({ additional_args = function() return { '--hidden' } end })<cr>",
  { silent = true, desc = "Find in  All Files" }
)

-- Oil
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Copy file name and the line number to clipboard
map("n", "<Leader>l", ":let @+ = expand('%') . ':' . line('.')<cr>",{desc="Copy file name and the line number"})


