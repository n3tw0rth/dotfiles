---@type ChadrcConfig
local M = {}

M.ui = {
  statusline = {
    theme = "vscode",
  },
  telescope = {
    style = "bordered"
  },

}

M.base46 = {
  theme = "monochrome",

  transparency = true,

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

return M
