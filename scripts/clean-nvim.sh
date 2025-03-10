#!/usr/bin/bash

rm -rf "${HOME}/.local/state/nvim"
# exclude dadbod_ui
find "${HOME}/.local/share/nvim" -mindepth 1 -maxdepth 1 ! -name "dadbod_ui" -exec rm -rf {} +
rm -rf "${HOME}/.cache/nvim"
