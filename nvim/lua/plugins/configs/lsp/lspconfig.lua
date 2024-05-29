local utils = require("utils.functions")
local nvim_lsp = require("lspconfig")
local settings = require("core.settings")
local lsp_settings = require("plugins.configs.lsp.settings")
local navic = require("nvim-navic")

local M = {}

-------------------- on_attach logic ----------------------

M.on_attach = function(client, bufnr)
  utils.load_mappings("lspconfig", { buffer = bufnr })
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end
-------------------- on_attach logic ----------------------

-------------------- capablities logic --------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}

M.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
-- set folding after capabilities from cmp_nvim_lsp to nvim-ufo can fold yaml
M.capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

-------------------- capablities logic --------------------

local servers = settings.lsp_servers

require("neodev").setup({})
for _, lsp in ipairs(servers) do
  local server_config = {
    before_init = function(_, config)
      -- jedi_language_server is capable of automatically detecting virtual environments
      if lsp == "jedi_language_server" then
        local lsp_utils = require("plugins.configs.lsp.utils")
        config.initializationOptions.workspace.environmentPath = lsp_utils.get_python_path(config.root_dir)
      end
    end,
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    settings = {
      html = lsp_settings.html,
      Lua = lsp_settings.lua,
      yaml = lsp_settings.yaml,
    },
  }

  nvim_lsp[lsp].setup(server_config)
end
