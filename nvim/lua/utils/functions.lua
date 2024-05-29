local M = {}
local merge_tb = vim.tbl_deep_extend

M.load_config = function()
  local config = {}

  config.mappings = {}

  config.mappings = require("core.mappings")

  return config
end

M.load_mappings = function(section, mapping_opt)
  vim.schedule(function()
    local function set_section_map(section_values)
      if section_values.plugin then
        return
      end

      section_values.plugin = nil

      for mode, mode_values in pairs(section_values) do
        local default_opts = merge_tb("force", { mode = mode }, mapping_opt or {})
        for keybind, mapping_info in pairs(mode_values) do
          -- merge default + user opts
          local opts = merge_tb("force", default_opts, mapping_info.opts or {})
          mapping_info.opts, opts.mode = nil, nil
          opts.desc = mapping_info[2]
          vim.keymap.set(mode, keybind, mapping_info[1], opts)
        end
      end
    end

    local mappings = require("utils.functions").load_config().mappings

    if type(section) == "string" then
      mappings[section]["plugin"] = nil
      mappings = { mappings[section] }
    end

    for _, sect in pairs(mappings) do
      set_section_map(sect)
    end
  end)
end

M.toggle_term_mappings = function()
  local map = vim.api.nvim_set_keymap
  local buf_map = vim.api.nvim_buf_set_keymap

  map("t", "<ESC>", "<C-\\><C-n>", { noremap = true, silent = true }) -- back to normal mode in Terminal

  -- Better navigation to and from terminal
  local set_terminal_keymaps = function()
    local opts = { noremap = true }
    buf_map(0, "t", "<esc>", [[<C-\><C-n>]], opts)
    buf_map(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
    buf_map(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
    buf_map(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
    buf_map(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
  end
  -- if you only want these mappings for toggle term use term://*toggleterm#* instead
  vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "term://*",
    callback = function()
      set_terminal_keymaps()
    end,
    desc = "Mappings for navigation with a terminal",
  })
end

M.lazy_load = function(plugin)
  vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("BeLazyOnFileOpen" .. plugin, {}),
    callback = function()
      local file = vim.fn.expand("%")
      local condition = file ~= "NvimTree_1" and file ~= "[lazy]" and file ~= ""

      if condition then
        vim.api.nvim_del_augroup_by_name("BeLazyOnFileOpen" .. plugin)

        -- dont defer for treesitter as it will show slow highlighting
        -- This deferring only happens only when we do "nvim filename"
        if plugin ~= "nvim-treesitter" then
          vim.schedule(function()
            require("lazy").load({ plugins = plugin })
            if plugin == "nvim-lspconfig" then
              vim.cmd("silent! do FileType")
            end
          end, 0)
        else
          require("lazy").load({ plugins = plugin })
        end
      end
    end,
  })
end

M.status_line = function()
  local mode = "%-5{%v:lua.string.upper(v:lua.vim.fn.mode())%}"
  local file_name = "%-.16t"
  local buf_nr = "[%n]"
  local modified = " %-m"
  local file_type = " %y"
  local right_align = "%="
  local line_no = "%10([%l/%L%)]"
  local pct_thru_file = "%5p%%"

  return string.format(
    "%s%s%s%s%s%s%s%s",
    mode,
    file_name,
    buf_nr,
    modified,
    file_type,
    right_align,
    line_no,
    pct_thru_file
  )
end

M.is_empty = function(s)
  return s == nil or s == ""
end

M.notify = function(message, level, title)
  local notify_options = {
    title = title,
    timeout = 2000,
  }
  vim.api.nvim_notify(message, level, notify_options)
end

M.get_buf_option = function(opt)
  local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
  if not status_ok then
    return nil
  else
    return buf_option
  end
end

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end



function ToggleVirtualText()

  local virtual_text_enabled = true
  virtual_text_enabled = not virtual_text_enabled
  vim.diagnostic.config({
    virtual_text = virtual_text_enabled,
    -- You can add other diagnostic configurations here if needed
  })
end

return M
