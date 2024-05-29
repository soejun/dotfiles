-- master DAP configuration file

local M = {}

local function configure()
  -- TODO Fix this
  local dap_breakpoint = {
    error = {
      text = "🟥",
      texthl = "LspDiagnosticsSignError",
      linehl = "",
      numhl = "",
    },
    rejected = {
      text = "",
      texthl = "LspDiagnosticsSignHint",
      linehl = "",
      numhl = "",
    },
    stopped = {
      text = "⭐️",
      texthl = "LspDiagnosticsSignInformation",
      linehl = "DiagnosticUnderlineInfo",
      numhl = "LspDiagnosticsSignInformation",
    },
  }
  vim.fn.sign_define("DapBreakPoint", dap_breakpoint.error)
  vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
  vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)
end

local function configure_exts()
  require("nvim-dap-virtual-text").setup({
    commented = true,
  })
end

local function configure_debuggers()
  -- require("configs.plugins.dap.lua")
  require("configs.plugins.dap.go")
  require("configs.plugins.dap.python")
end

local function create_mapping()
  local wk = require("which-key")
  wk.register({
    d = { "Debug" },
  }, { prefix = "<leader>", mode = "n", { silent = true } })
end

function M.setup()
  configure() --Configuration
  configure_exts() --Extensions
  configure_debuggers() --Debugger
  create_mapping() --which-key mapping
end

return M
