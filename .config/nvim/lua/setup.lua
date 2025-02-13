require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  {
    "supermaven-inc/supermaven-nvim",
  },
  { import = "plugins" },
}, lazy_config)

require("oil").setup({
  default_file_explorer = false,
  view_options = {
    show_hidden = true,
  }
})

require("supermaven-nvim").setup({
  keymaps = {
    accept_suggestion = "<A-Tab>",
    -- clear_suggestion = "<C-]>",
    -- accept_word = "<C-j>",
  },
        ignore_filetypes = { "rust" },
      })

require("nvim-tree").setup {
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    cursorline = true,
    width = 50,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
}

require('leap').add_default_mappings()
