#!/bin/bash

dotfiles="${HOME}/Workspace/dotfiles"

aerospace_wm=("aerospace" "yabai")
apps=("kitty" "ranger" "tmux" "zathura")

configurations=("${apps[@]}" "${aerospace_wm[@]}")

for config in "${configurations[@]}"; do
  ln -sf "${dotfiles}/config/${config}" "${HOME}/.config/"
done

ln -sf "${HOME}/.config/kitty/kitty-macos.conf" "${HOME}/.config/kitty/kitty.conf"

ln -sf "${dotfiles}/config/vimrc" "${HOME}/.vimrc"
