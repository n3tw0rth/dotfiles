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
    NvimTreeNormal = { fg = '#9AA6B2' },
    NvimTreeFolderName = { fg = '#9AA6B2' },
    NvimTreeOpenedFolderName = { fg = '#9AA6B2' },
    NvimTreeRootFolderName = { fg = '#9AA6B2' },
    NvimTreeSymlink = { fg = '#9AA6B2' },
    NvimTreeExecFile = { fg = '#9AA6B2' },
    NvimTreeFile = { fg = '#9AA6B2' },
    NvimTreeIndentMarker = { fg = '#9AA6B2' },
    NvimTreeFolderIcon = { fg = '#9AA6B2' },
    NvimTreeCursorLine = { fg = '#9AA6B2' },
  },
}

return M
