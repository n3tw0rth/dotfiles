return {
  "zk-org/zk-nvim",
  ft = "markdown",
  cmd = { "ZkNew", "ZkNotes", "ZkTags", "ZkLinks", "ZkBacklinks", "ZkInsertLink", "ZkMatch" },
  keys = {
    { "<leader>kn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", desc = "Zk New note" },
    { "<leader>kd", "<Cmd>ZkNew { dir = 'daily' }<CR>", desc = "Zk Daily note" },
    { "<leader>kw", "<Cmd>ZkNew { dir = 'writeups', title = vim.fn.input('Writeup: '), extra = { platform = vim.fn.input('Platform: ') } }<CR>", desc = "Zk Writeup" },
    { "<leader>ko", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", desc = "Zk Open notes" },
    { "<leader>kt", "<Cmd>ZkTags<CR>", desc = "Zk Browse tags" },
    { "<leader>kf", "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>", desc = "Zk Search notes" },
    { "<leader>kf", ":'<,'>ZkMatch<CR>", mode = "v", desc = "Zk Search selection" },
    { "<leader>kb", "<Cmd>ZkBacklinks<CR>", desc = "Zk Backlinks" },
    { "<leader>kl", "<Cmd>ZkLinks<CR>", desc = "Zk Outbound links" },
    { "<leader>ki", "<Cmd>ZkInsertLink<CR>", desc = "Zk Insert link" },
  },
  init = function()
    -- Fallback notebook when the buffer/cwd isn't in one; don't rely on the shell having exported it
    vim.env.ZK_NOTEBOOK_DIR = vim.env.ZK_NOTEBOOK_DIR or vim.fn.expand "~/notes"
  end,
  config = function()
    require("zk").setup {
      picker = "telescope",
      lsp = {
        config = {
          name = "zk",
          cmd = { "zk", "lsp" },
          filetypes = { "markdown" },
        },
        auto_attach = { enabled = true },
      },
    }
  end,
}
