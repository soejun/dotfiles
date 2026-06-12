# Fish config — CachyOS / Hyprland box.
#
# Ported and ADAPTED from shells/zshrc (the Debian/kitty zsh setup): aliases,
# env, terminal title, and a starship prompt carry over; Debian-only PATHs
# (nvim-linux, jdk, linuxbrew, snap, nvm) are dropped because those tools come
# from pacman here. Managed in the dotfiles repo.

# Keep CachyOS's own fish setup (aliases, completions, greeting).
if test -f /usr/share/cachyos-fish-config/cachyos-config.fish
    source /usr/share/cachyos-fish-config/cachyos-config.fish
end

# PATH — cargo is handled by conf.d/rustup.fish; node/npm/nvim/fzf are in
# /usr/bin already. Only ~/.local/bin needs adding (idempotent).
fish_add_path $HOME/.local/bin

# Environment
set -gx EDITOR nvim
set -gx MANPAGER "nvim +Man!"
set -gx UV_NATIVE_TLS true

# Aliases (from zshrc)
alias git-branch-name "git rev-parse --abbrev-ref HEAD"
alias lsplog "tail -f ~/.local/state/nvim/lsp.log"
alias leetcode "nvim leetcode.nvim"
alias make-gif "~/Workspace/dotfiles/scripts/gif-maker.sh"

# In kitty, force a known TERM over ssh.
if test "$TERM" = xterm-kitty
    alias ssh "TERM=xterm-256color ssh"
end

# fzf quick directory jump (zsh `sd`)
function sd
    cd ~; and cd (find * -type d | fzf)
end

# Dockerized `play` sandbox (from zshrc)
function play-docker
    docker run -e "TERM=xterm-256color" --rm -it -v "$PWD":"$PWD" -w "$PWD" plazzari/play:latest
end

# Terminal title: "~/dir | running-command" (kitty tabs), from zsh preexec/precmd.
function fish_title
    set -l dir (string replace -r "^$HOME" "~" "$PWD")
    if set -q argv[1]
        echo "$dir | $argv[1]"
    else
        echo "$dir"
    end
end

# fzf key bindings + completion (Ctrl-R history, Ctrl-T files)
if command -v fzf >/dev/null
    fzf --fish | source
end

# Prompt — starship (Tokyo Night). Guarded until the package is installed.
if command -v starship >/dev/null
    starship init fish | source
end
