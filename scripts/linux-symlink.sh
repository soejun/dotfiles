#!/bin/bash

dotfiles="${HOME}/Workspace/dotfiles"

apps=("kitty" "ranger" "tmux" "zathura")

sway_wm=("sway" "swaylock" "waybar" "wofi")

configurations=("${apps[@]}" "${sway_wm[@]}")

for config in "${configurations[@]}"; do
  ln -sf "${dotfiles}/config/${config}" "${HOME}/.config/"
done

ln -sf "${HOME}/.config/kitty/kitty-linux.conf" "${HOME}/.config/kitty/kitty.conf"

ln -sf "${dotfiles}/config/vimrc" "${HOME}/.vimrc"
