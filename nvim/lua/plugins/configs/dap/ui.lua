local opts = {}

opts = {
  controls = {
    element = "repl",
    enabled = true,
    icons = {
      disconnect = "",
      pause = "",
      play = "",
      run_last = "",
      step_back = "",
      step_into = "",
      step_out = "",
      step_over = "",
      terminate = "",
    },
  },
  element_mappings = {},
  expand_lines = true,
  floating = {
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  force_buffers = true,
  icons = {
    collapsed = "",
    current_frame = "",
    expanded = "",
  },
  layouts = {
    {
      elements = {
        {
          id = "breakpoints",
          size = 0.175,
        },
        {
          id = "stacks",
          size = 0.175,
        },

        {
          id = "scopes",
          size = 0.3,
        },

        {
          id = "watches",
          size = 0.35,
        },
      },
      position = "left",
      size = 0.3,
    },
    {
      elements = {
        {
          id = "repl",
          size = 0.6,
        },

        {
          id = "console",
          size = 0.4,
        },
      },
      position = "bottom",
      size = 0.35,
    },
  },
  mappings = {
    edit = "e",
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    repl = "r",
    toggle = "t",
  },
  render = {
    indent = 1,
    max_value_lines = 130,
  },
}

return opts
