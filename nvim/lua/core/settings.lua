local M = {}

M.global_statusline = true -- Toggle global status line
M.grepprg = "rg --hidden --vimgrep --smart-case --" -- use rg instead of grep, unused for now
M.showtabline = 1 -- enable or disable listchars
M.list = false
M.listchars = "eol:¬,tab:>·,trail:~,extends:>,precedes:<" -- which list chars to schow
M.enable_noice = true -- Noice heavily changes the Neovim UI ...
M.disable_winbar = false -- Disable winbar with nvim-navic location
M.dashboard_recent_files = 5 -- Number of recent files shown in dashboard, 0 disables showing recent files
M.disable_dashboard_header = false -- disable the header of the dashboard
M.disable_dashboard_quick_links = false -- disable quick links of the dashboard

-- treesitter parsers to be installed
-- one of "all", "maintained" (parsers with maintainers), or a list of languages
M.treesitter_ensure_installed = {
  -- languages --
  "bash",
  "c",
  "c_sharp",
  "javascript",
  "go",
  "lua",
  "python",
  "typescript",
  -- languages --
  -- config file types --
  "json",
  "ini",
  "toml",
  "yaml",
  "xml",
  "git_config",
  "git_rebase",
  "gitignore",
  "gitattributes",
  "gitcommit",
  -- config file types --
  -- misc --
  "make",
  "cmake",
  "dockerfile",
  "css",
  "scss",
  "gomod",
  "gosum",
  "html",
  "markdown",
  "markdown_inline",
  -- misc --
  "query",
  "regex",
  "tsx",
  "vim",
  "vimdoc",
  -- misc --
}

-- LSPs that should be installed by Mason-lspconfig
M.lsp_servers = {
  "bashls",
  "clangd",
  "dockerls",
  "jsonls",
  "gopls",
  "html",
  "nginx_language_server",
  "marksman",
  "jedi_language_server",
  "lua_ls",
  "tsserver",
  "yamlls",
}

-- Linters, formatters, and debuggers installed by mason
-- TODO, yapf, black, pylint and associated python tools from null_ls should be pointed to virtual environments
M.tools = {
  -- Formatter
  -- "black",
  -- "yapf",
  "prettier",
  "stylua",
  "shfmt",
  -- Linter
  "eslint_d",
  "shellcheck",
  "tflint",
  "yamllint",
  -- "pylint",
  "ruff",
  -- DAP
  "debugpy",
}

-- LSP's installed by mason
M.mason_ensure_installed = {
  "bash-language-server",
  "clangd",
  "dockerfile-language-server",
  "json-lsp",
  "gopls",
  "html-lsp",
  "htmx-lsp",
  "marksman",
  "jedi-language-server",
  "lua-language-server",
  "nginx-language-server",
  "typescript-language-server",
  "yaml-language-server",
}

return M
