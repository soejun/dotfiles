-- lsp config for csharp_ls

local csharp_ls_binary = "/home/wchan/.dotnet/tools/csharp-ls"

return {
  cmd = { csharp_ls_binary },
  handlers = {
    ["textDocument/definition"] = require("csharpls_extended").handler,
    ["textDocument/typeDefinition"] = require("csharpls_extended").handler,
  },
  filetypes = { "cs", "vb" },
}
