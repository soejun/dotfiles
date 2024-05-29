local M = {}
-- The debugger will automatically pick-up another virtual environment if it is activated before neovim is started.

function M.setup(_)
  require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
end

return M
