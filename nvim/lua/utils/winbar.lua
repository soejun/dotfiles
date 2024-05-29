local M = {}

local navic = require("nvim-navic")
local utils = require("utils.functions")
local icons = require("utils.alpha2phi-icons")

M.winbar_filetype_exclude = {
  "help",
  "startify",
  "dashboard",
  "packer",
  "neogitstatus",
  "NvimTree",
  "Trouble",
  "alpha",
  "lir",
  "Outline",
  "spectre_panel",
  "toggleterm",
}

local excludes = function()
  if vim.tbl_contains(M.winbar_filetype_exclude, vim.bo.filetype) then
    vim.opt_local.winbar = nil
    return true
  end
  return false
end

local function get_modified()
  -- %t, just the current buffer
  -- %f, includes parent
  -- %f, absolute path
  if utils.get_buf_option("mod") then
    local mod = icons.git.Mod
    return "%#WinBarFilename#" .. mod .. " " .. "%f" .. "%*"
  end
  return "%#WinBarFilename#" .. "%f" .. "%*"
end

local function get_location()
  local location = navic.get_location()
  if not utils.is_empty(location) then
    return "%#WinBarContext#" .. " " .. icons.ui.ChevronRight .. " " .. location .. "%*"
  end
  return ""
end

M.get_winbar = function()
  if excludes() then
    return ""
  end
  if navic.is_available() then
    return "%#WinBarSeparator#"
      .. "%="
      -- .. ""
      .. "%*"
      .. get_modified()
      .. get_location()
      .. "%#WinBarSeparator#"
      -- .. ""
      .. "%*  " -- Append whitespace for margin, crappy fix? Maybe but it works lol
  else
    return "%#WinBarSeparator#" .. "%=" .. "%*" .. get_modified() .. "%#WinBarSeparator#" .. "%*"
  end
end

return M
