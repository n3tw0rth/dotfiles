---@type ChadrcConfig
local M = {}

local fg_color = { fg = "#9AA6B2" }

M.ui = {
  statusline = {
    theme = "vscode",
  },
  telescope = {
    style = "bordered",
  },
  cmp = {
    icons = false,
    style = "default",
    icons_left = false,
  },
}

M.base46 = {
  theme = "monochrome",

  transparency = true,

  hl_override = {
    ["@property"] = fg_color,
    ["@variable.member"] = fg_color,
    ["@punctuation.bracket"] = fg_color,
    Keyword = fg_color,
    Macro = fg_color,
    Conditional = fg_color,
    Identifier = fg_color,
    Special = fg_color,
    NvimTreeNormal = fg_color,
    NvimTreeFolderName = fg_color,
    NvimTreeOpenedFolderName = fg_color,
    NvimTreeRootFolderName = fg_color,
    NvimTreeSymlink = fg_color,
    NvimTreeExecFile = fg_color,
    NvimTreeFile = fg_color,
    NvimTreeFileIcon = fg_color,
    NvimTreeIndentMarker = fg_color,
    NvimTreeFolderIcon = fg_color,
    NvimTreeCursorLine = fg_color,
    LineNrAbove = fg_color,
    LineNrBelow = fg_color,
    CursorLineNr = { fg = "white" },
    ZenBg = { fg = "none" }

  },
}

return M
