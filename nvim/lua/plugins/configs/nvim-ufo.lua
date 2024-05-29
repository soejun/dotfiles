--nvim-ufo config, for folding

local options = {}

options = {
  provider_selector = function(bufnr, filetype)
        return { "lsp", "treesitter", "indent" }
   end,
}

return options
