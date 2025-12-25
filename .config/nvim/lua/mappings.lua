require "nvchad.mappings"

local map = vim.keymap.set

map("i", "jk", "<ESC>", { desc = "Shortcut Quick normal model" })
map("n", ";", ":", { desc = "Shortcut Map ; to :" })
map(
  "n",
  "<leader>l",
  ":let @+ = expand('%') . ':' . line('.')<cr>",
  { desc = "Shortcut Copy filepath and line number" }
)

map("n", "<leader>gb", require("gitsigns").toggle_current_line_blame, { desc = "inline git blames" })
map(
  "n",
  "<leader><leader>x",
  [[:%bdelete|edit #|normal`"<CR>]],
  { desc = "Shortcut Close all buffers except current one" }
)

-- Replace
map({ "n", "v" }, "<leader>ck", [[:s/\v-([a-z])/_\1/g<CR>]], { desc = "Case kebab to snake" })
map({ "n", "v" }, "<leader>cc", [[:s/\v_(\w)/\U\1/g<CR>:s/\v(^\l)/\L\1/<CR>]], { desc = "Case snake to camel" })

-- telescope
map("n", "<leader>gG", require("telescope.builtin").git_branches, { desc = "Telescope Checkout git branch" })
map("n", "<leader>gs", require("telescope.builtin").git_status, { desc = "Telescope Open current modified files" })
map("n", "<leader>fr", require("telescope.builtin").resume, { desc = "Telescope Resume the previous picker" })
map("n", "<leader>fm", require("telescope.builtin").marks, { desc = "Telescope Show marks" })
map("n", "<leader>fs", require("telescope.builtin").grep_string, { desc = "Telescope Grep string under cursor" })
map("n", "<leader>fi", require("telescope.builtin").lsp_implementations, { desc = "Telescope Show implementations" })
map(
  "n",
  "<leader>fw",
  ":lua require('telescope.builtin').live_grep({ additional_args = function() return { '--hidden' } end })<cr>",
  { silent = true, desc = "Telescope Find in  All Files" }
)

map("n", "-", "<CMD>Oil<CR>", { desc = "Plugin Open parent directory" })
map("n", "_", "<CMD>Scrub<CR>", { desc = "Plugin Run Scrub" })
map("n", "<leader>z", ":ZenMode<CR>", { desc = "Plugin Enter ZenMode" })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    map("n", "gD", vim.lsp.buf.declaration, opts)
    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "gr", vim.lsp.buf.references, opts)
    map("n", "gi", vim.lsp.buf.implementation, opts)
    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    map({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, { unpack(opts), desc = "Code Action" })
    map("n", "<space>D", vim.lsp.buf.type_definition, opts)
    map("n", "<space>rn", vim.lsp.buf.rename, opts)
  end,
})

vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
vim.keymap.set('n',             'S', '<Plug>(leap-from-window)')
