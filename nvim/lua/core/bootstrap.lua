local M = {}

M.lazy = function(install_path)
  ------------- lazy.nvim ---------------
  --M.echo "  Installing lazy.nvim & plugins ..."
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, install_path })
  vim.opt.rtp:prepend(install_path)

  -- install plugins
  require("plugins")

  -- install mason packages
  require("utils.post_bootstrap").mason_install()
end

return M
