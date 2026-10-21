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

    local url = vim.uri_from_fname(node.absolute_path)
    if vim.env.BROWSER then
      vim.fn.jobstart({ vim.env.BROWSER, url }, { detach = true })
      return
    end

    -- xdg-open picks the app by mime type (markdown goes to the editor), so launch the default browser by name
    local desktop = vim.trim(vim.fn.system { "xdg-settings", "get", "default-web-browser" })
    if vim.v.shell_error ~= 0 or desktop == "" or vim.fn.executable "gtk-launch" == 0 then
      vim.notify("No default browser found; set $BROWSER", vim.log.levels.WARN)
      return
    end
    vim.fn.jobstart({ "gtk-launch", desktop, url }, { detach = true })
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
