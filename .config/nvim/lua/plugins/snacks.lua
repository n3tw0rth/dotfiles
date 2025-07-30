return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  ---@class snacks.notifier.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = [[

███╗   ██╗██╗   ██╗██╗███╗   ███╗    ██████╗ ████████╗██╗    ██╗
████╗  ██║██║   ██║██║████╗ ████║    ██╔══██╗╚══██╔══╝██║    ██║
██╔██╗ ██║██║   ██║██║██╔████╔██║    ██████╔╝   ██║   ██║ █╗ ██║
██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║    ██╔══██╗   ██║   ██║███╗██║
██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║    ██████╔╝   ██║   ╚███╔███╔╝
╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝    ╚═════╝    ╚═╝    ╚══╝╚══╝

]]
      }
    },
    notifier = {
      enabled = true,
      timeout = 5000,
      style = "minimal"
    },
    quickfile = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        wo = { wrap = true }, -- Wrap notifications
      }
    }
  },
  theme = {
      [241]                      = { fg = "Special" },
      activeBorderColor          = { fg = "#9AA6B2", bold = true },
      cherryPickedCommitBgColor  = { fg = "Identifier" },
      cherryPickedCommitFgColor  = { fg = "Function" },
      defaultFgColor             = { fg = "Normal" },
      inactiveBorderColor        = { fg = "#5A646E" },
      optionsTextColor           = { fg = "#9AA6B2" },
      searchingActiveBorderColor = { fg = "MatchParen", bold = true },
      selectedLineBgColor        = { bg = "Visual" }, -- set to `default` to have no background colour
      unstagedChangesColor       = { fg = "DiagnosticError" },
  },
  keys = {
    { "<leader>N",  function() Snacks.notifier.show_history() end,   desc = "Notification History" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>gB", function() Snacks.gitbrowse() end,          desc = "Git Browse" },
    { "<leader>gf", function() Snacks.lazygit.log_file() end,   desc = "Lazygit Current File History" },
    { "<leader>gg", function() Snacks.lazygit() end,            desc = "Lazygit" },
    { "<leader>gl", function() Snacks.lazygit.log() end,        desc = "Lazygit Log (cwd)" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        -- Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        -- Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        -- Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
        -- "<leader>uc")
        -- Snacks.toggle.treesitter():map("<leader>uT")
        -- Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        -- Snacks.toggle.inlay_hints():map("<leader>uh")
      end,
    })
  end,
}
