#!/usr/bin/env bash
# WSL (Debian) development environment setup
# Mirrors the Linux/macOS dotfiles workflow:
#   - zsh + oh-my-zsh + powerlevel10k
#   - zsh-autosuggestions, zsh-syntax-highlighting
#   - neovim (latest stable AppImage/tarball)
#   - uv (Python), nvm (Node), rustup, go
#   - ripgrep, fzf, lf
#
# Usage (inside WSL Debian shell):
#   bash setup-wsl.sh
#   # Then restart the shell (exec zsh) or open a new terminal.

set -euo pipefail

DOTFILES_REPO="https://github.com/YOUR_USERNAME/dotfiles"  # update this
NVIM_VERSION="v0.10.4"
GO_VERSION="1.24.1"
NVM_VERSION="v0.40.2"

log()  { printf '\n\033[36m==> %s\033[0m\n' "$*"; }
ok()   { printf '\033[32m    %s\033[0m\n' "$*"; }
warn() { printf '\033[33m    WARN: %s\033[0m\n' "$*"; }

# ---------------------------------------------------------------------------
# 1. Base packages
# ---------------------------------------------------------------------------
log "Updating packages..."
sudo apt update && sudo apt upgrade -y

log "Installing base packages..."
sudo apt install -y \
    zsh curl git wget unzip build-essential \
    ripgrep fzf python3 python3-pip python3-venv \
    gcc make cmake pkg-config \
    xclip xdg-utils ca-certificates \
    fd-find bat

# fd and bat have different binary names on Debian
[ ! -f ~/.local/bin/fd  ] && mkdir -p ~/.local/bin && ln -sf "$(which fdfind)" ~/.local/bin/fd 2>/dev/null || true
[ ! -f ~/.local/bin/bat ] && ln -sf "$(which batcat)" ~/.local/bin/bat 2>/dev/null || true

# ---------------------------------------------------------------------------
# 2. zsh as default shell
# ---------------------------------------------------------------------------
log "Setting zsh as default shell..."
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
    ok "zsh set as default. It takes effect on next login."
else
    ok "zsh already default."
fi

# ---------------------------------------------------------------------------
# 3. Oh My Zsh
# ---------------------------------------------------------------------------
log "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
        "" --unattended
else
    ok "oh-my-zsh already installed."
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# ---------------------------------------------------------------------------
# 4. Powerlevel10k
# ---------------------------------------------------------------------------
log "Installing Powerlevel10k..."
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "$ZSH_CUSTOM/themes/powerlevel10k"
else
    ok "powerlevel10k already installed."
fi

# ---------------------------------------------------------------------------
# 5. zsh plugins
# ---------------------------------------------------------------------------
log "Installing zsh plugins..."
for plugin in \
    "zsh-users/zsh-autosuggestions" \
    "zsh-users/zsh-syntax-highlighting"
do
    dir="$ZSH_CUSTOM/plugins/$(basename $plugin)"
    if [ ! -d "$dir" ]; then
        git clone "https://github.com/$plugin.git" "$dir"
    else
        ok "$(basename $plugin) already installed."
    fi
done

# ---------------------------------------------------------------------------
# 6. Neovim
# ---------------------------------------------------------------------------
log "Installing Neovim $NVIM_VERSION..."
NVIM_TARBALL="nvim-linux-x86_64.tar.gz"
if ! command -v nvim &>/dev/null || [[ "$(nvim --version | head -1)" != *"${NVIM_VERSION#v}"* ]]; then
    curl -LO "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${NVIM_TARBALL}"
    sudo rm -rf /opt/nvim-linux-x86_64
    sudo tar -C /opt -xzf "$NVIM_TARBALL"
    rm "$NVIM_TARBALL"
    sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
    ok "Neovim $NVIM_VERSION installed."
else
    ok "Neovim already up to date."
fi

# ---------------------------------------------------------------------------
# 7. uv (Python toolchain — mirrors your Linux workflow)
# ---------------------------------------------------------------------------
log "Installing uv..."
if ! command -v uv &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    ok "uv installed."
else
    ok "uv already installed."
fi

# ---------------------------------------------------------------------------
# 8. nvm + Node LTS
# ---------------------------------------------------------------------------
log "Installing nvm $NVM_VERSION..."
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
fi
# Load nvm for this session
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default node
ok "Node $(node --version) installed."

# ---------------------------------------------------------------------------
# 9. Rust / cargo
# ---------------------------------------------------------------------------
log "Installing Rust..."
if ! command -v rustup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    ok "Rust installed."
else
    rustup update
    ok "Rust already installed, updated."
fi

# ---------------------------------------------------------------------------
# 10. Go
# ---------------------------------------------------------------------------
log "Installing Go $GO_VERSION..."
GO_TARBALL="go${GO_VERSION}.linux-amd64.tar.gz"
if ! command -v go &>/dev/null || [[ "$(go version)" != *"go${GO_VERSION}"* ]]; then
    curl -LO "https://go.dev/dl/$GO_TARBALL"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "$GO_TARBALL"
    rm "$GO_TARBALL"
    ok "Go $GO_VERSION installed."
else
    ok "Go already installed."
fi

# ---------------------------------------------------------------------------
# 11. lf (terminal file manager — cross-platform, like ranger)
# ---------------------------------------------------------------------------
log "Installing lf..."
if ! command -v lf &>/dev/null; then
    LF_URL="https://github.com/gokcehan/lf/releases/latest/download/lf-linux-amd64.tar.gz"
    curl -L "$LF_URL" | sudo tar -C /usr/local/bin -xzf -
    ok "lf installed."
else
    ok "lf already installed."
fi

# ---------------------------------------------------------------------------
# 12. Homebrew (optional — matches your Linux brew usage)
# ---------------------------------------------------------------------------
log "Installing Homebrew..."
if ! command -v brew &>/dev/null; then
    NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ok "Homebrew installed."
else
    ok "Homebrew already installed."
fi

# ---------------------------------------------------------------------------
# 13. Write .zshrc
# ---------------------------------------------------------------------------
log "Writing ~/.zshrc..."
cat > "$HOME/.zshrc" << 'ZSHRC'
# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Interactive check
case $- in *i*) ;; *) return ;; esac

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  web-search
)

source $ZSH/oh-my-zsh.sh

unsetopt BEEP
DISABLE_AUTO_TITLE="true"

# --- Paths ---
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:/usr/local/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$PATH:$HOME/.local/share/nvim/mason/bin"

# --- Editor ---
export EDITOR=nvim
export MANPAGER="nvim +Man!"

# --- uv ---
export UV_NATIVE_TLS=true
. "$HOME/.cargo/env" 2>/dev/null || true

# --- nvm ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --- Homebrew ---
if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# --- Aliases ---
alias lsplog='tail -f ~/.local/state/nvim/lsp.log'
alias git-branch-name='git rev-parse --abbrev-ref HEAD'
alias sd="cd ~ && cd \$(find * -type d | fzf)"

# --- Terminal title ---
function set_terminal_title() {
  local display_dir="${PWD/#$HOME/~}"
  if [[ -n "$1" ]]; then
    print -Pn "\e]0;$display_dir | $1\a"
  else
    print -Pn "\e]0;$display_dir\a"
  fi
}
function preexec() { set_terminal_title "$1" }
function precmd()  { set_terminal_title }
set_terminal_title

# --- WSL-specific: open Windows browser from WSL ---
if grep -qi microsoft /proc/version 2>/dev/null; then
  export BROWSER='wslview'
fi

# p10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
ZSHRC

ok ".zshrc written."

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
printf '\n\033[32m==> WSL setup complete!\033[0m\n'
cat << 'MSG'

Next steps:
  1. Start zsh:
       exec zsh
  2. Run `p10k configure` to set up your prompt.
  3. Clone your LazyVim config into ~/.config/nvim, then open nvim.
  4. (Optional) Link dotfiles:
       ln -sf /mnt/c/Users/<YOU>/dotfiles/shells/zshrc ~/.zshrc

MSG
