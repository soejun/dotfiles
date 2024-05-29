local api = vim.api
local M = {}

M.mason_install = function ()
    vim.cmd "MasonInstallAll"
    -- Keep track of which mason pkgs get installed
    local packages = table.concat(vim.g.mason_binaries_list, " ")
    require("mason-registry"):on("package:install:success", function(pkg)
        packages = string.gsub(packages, pkg.name:gsub("%-", "%%-"), "") -- rm package name

        -- run above screen func after all pkgs are installed.
        if packages:match "%S" == nil then
          vim.schedule(function()
            api.nvim_buf_delete(0, { force = true })
            vim.cmd "echo '' | redraw" -- clear cmdline
          end)
        end
    end)
end

return M
