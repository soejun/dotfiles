require("core.options") -- all non plugin related (vim) options
require("utils.functions").load_mappings() --load mappings

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").lazy(lazypath)
end

vim.opt.rtp:prepend({ lazypath })

require("plugins") --plugin management via lazy
require("core.autocmd") -- vim autocommands/autogroups
vim.cmd([[  set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175]])
AUTOFORMAT_ACTIVE = false
