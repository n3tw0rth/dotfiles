-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M               = {}

M.ui                  = {
  theme = "monochrome",
  transparency = true,

  statusline = {
    theme = "vscode"
  }

  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

M.base46.theme        = "monochrome"
M.base46.transparency = true

return M
