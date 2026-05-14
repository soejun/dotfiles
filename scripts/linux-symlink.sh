#!/bin/bash

dotfiles="${HOME}/Workspace/dotfiles"

apps=("kitty" "ranger" "tmux" "zathura" "posting")

sway_wm=("sway" "swaylock" "waybar" "wofi" "swaync")

configurations=("${apps[@]}" "${sway_wm[@]}")

for config in "${configurations[@]}"; do
  ln -sf "${dotfiles}/config/${config}" "${HOME}/.config/"
done

ln -sf "${HOME}/.config/kitty/kitty-linux.conf" "${HOME}/.config/kitty/kitty.conf"

ln -sf "${dotfiles}/config/vimrc" "${HOME}/.vimrc"

# Sway session launcher (sets XDG_CURRENT_DESKTOP=sway etc. before exec sway).
# Without this, xdg-desktop-portal can't route screencast to the wlr backend,
# breaking Teams "share entire screen" on Wayland.
mkdir -p "${HOME}/.local/bin" "${HOME}/.local/share/wayland-sessions"
ln -sf "${dotfiles}/config/sway/launcher/sway-session" "${HOME}/.local/bin/sway-session"
ln -sf "${dotfiles}/config/sway/launcher/sway.desktop" "${HOME}/.local/share/wayland-sessions/sway.desktop"
