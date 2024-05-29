local null_ls = require("null-ls")
local options = {}
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
options = {
 sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.formatting.prettier.with({
      extra_args = { "--single-quote", "false" },
    }),
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.goimports,
    null_ls.builtins.formatting.gofumpt,
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.formatting.shfmt,
  },
  -- on_attach = function(client, bufnr)
  --  if client.supports_method("textDocument/formatting") then
  --     vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  --     vim.api.nvim_create_autocmd("BufWritePre", {
  --       group = augroup,
  --       buffer = bufnr,
  --       callback = function()
  --         if AUTOFORMAT_ACTIVE then -- global var defined in functions.lua
  --           vim.lsp.buf.format({ bufnr = bufnr })
  --         end
  --       end,
  --     })
  --   end
  -- end,
}
return options
