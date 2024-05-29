-- lsp config for html
local opts = {}

opts = {
  cmd = { "vscode-html-language-server", "--stdio" },
  filetypes = {
    "html",
    "htmldjango",
    "jinja",
    "templ",
  },
  init_options = {
    configurationSection = { "html", "css", "javascript" },
    embeddedLanguages = {
      css = true,
      javascript = true,
    },
    provideFormatter = true,
  },
}

return opts
