require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },
  { import = "plugins" },
}, lazy_config)

local function nvimtree_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- keep all the default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- override `s`: open markdown in the browser (an extension renders it), else system open
  vim.keymap.set("n", "s", function()
    local node = api.tree.get_node_under_cursor()
    if not node or node.type ~= "file" then
      return
    end
    if node.extension ~= "md" and node.extension ~= "markdown" then
      api.node.run.system()
      return
    end

    local browser = vim.env.BROWSER or "xdg-open"
    vim.fn.jobstart({ browser, "file://" .. node.absolute_path }, { detach = true })
  end, opts("Open markdown in browser"))
end

require("nvim-tree").setup {
  on_attach = nvimtree_on_attach,
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
    git_ignored = false,
  },
  update_focused_file = {
    enable = true,
    update_root = {
      enable = false,
      ignore_list = {},
    },
    exclude = false,
  },
}
