-- lsp config for omnisharp

local omnisharp_dll = "/home/wchan/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll"
local pid = vim.fn.getpid()

local M = {}

M.cmd = {
  "dotnet",
  omnisharp_dll,
  "--languageserver",
  "--hostPID",
  tostring(pid),
}

M.handlers = {
  ["textDocument/definition"] = function(...)
    return require("omnisharp_extended").handler(...)
  end,
}

M.keys = {
  {
    "gd",
    function()
      require("omnisharp_extended").telescope_lsp_definitions()
    end,
    desc = "Goto Definition",
  },
}

M.settings = {
  init_options = {
    useGlobalMono = "always",
  },
  enable_roslyn_analyzers = true,
  organize_imports_on_format = true,
  enable_import_completion = true,
}

return M
