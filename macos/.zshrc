# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh" # Path to your oh-my-zsh installation.

# ==========EXTENSIONS AND CONFIGURATIONS========================================================================== #
ZSH_THEME="powerlevel10k/powerlevel10k"
alias vim="nvim"

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

export MANPAGER='nvim +Man!' #bat as the man page viewer, archive using nvim instead
# export MANPAGER="nvim -c 'set ft=man' -" # using nvim as default MANPAGER

plugins=(
          zsh-autosuggestions
          zsh-syntax-highlighting
          web-search
          zsh-tab-title)

  # ZSH_TAB_TITLE_ONLY_FOLDER=true
ZSH_TAB_TITLE_CONCAT_FOLDER_PROCESS=true
# ================================================================================================================= #

# ========= LANGUAGE PATH EXPORTS ================================================================================= #
#GOLANG
export GOPATH=$HOME/go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

#C++
export PATH="$HOME/tools/cmake/bin:$PATH"

#POSTGRESQL
#ITS REALLY JUST FOR VIM-DADBOD
export PATH="/usr/local/opt/libpq/bin:$PATH"
# ================================================================================================================= #

# ========= Shortcuts ================================================================================= #
# Basically for hard to rememebr directories ahem iCloud/macOS realted stuff
# ================================================================================================================= #
# TODO: make it so it doesn't echo duplicates
# echo 'icloud_guitar="/Users/soejun/Library/Mobile Documents/com~apple~CloudDocs/Guitar"' >> ~/.zshrc
# echo 'downloads_dir="/Users/soejun/Downloads/"' >> ~/.zshrc # for xargs commands
# ================================================================================================================= #

# https://egeek.me/2020/04/18/enabling-locate-on-osx/
if which glocate > /dev/null; then
  alias locate="glocate -d $HOME/locatedb"

  # Using cache_list requires `LOCATE_PATH` environment var to exist in session.
  # trouble shoot: `echo $LOCATE_PATH` needs to return db path.
  [[ -f "$HOME/locatedb" ]] && export LOCATE_PATH="$HOME/locatedb"
fi

alias loaddb="gupdatedb --localpaths=$HOME --prunepaths=/Volumes --output=$HOME/locatedb"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
alias cfg='/opt/homebrew/bin/git --git-dir=/Users/soejun/.cfg-repo/ --work-tree=/Users/soejun'

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


# pnpm
export PNPM_HOME="/Users/soejun/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#
alias python='python3'

export PATH=$PATH:/Users/soejun/.spicetify
export PATH="/opt/homebrew/opt/node@16/bin:$PATH"

# Zsh supports a shorthand notation =command
alias pylint="python =pylint"
