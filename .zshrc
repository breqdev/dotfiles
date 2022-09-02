# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && . "$HOME/.fig/shell/zshrc.pre.zsh"
# fig autocomplete

export PATH="/usr/local/bin:$PATH"

# homebrew on linux
if [[ `uname` == "Linux" ]]
then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# homebrew python
export PATH="$(brew --prefix python@3.10)/libexec/bin:$PATH"

# neofetch
neofetch

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export GPG_TTY=$(tty)

# TI-84 Plus CE toolchain
[ -s "$HOME/CEdev" ] && export PATH="$HOME/CEdev/bin:$PATH"

# Racket lang
[ -s "/Applications/Racket\ v8.2" ] && export PATH="/Applications/Racket\ v8.2/bin:$PATH"

# Java OpenJDK
[ -s "/opt/homebrew/opt/openjdk" ] && export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# rust
export PATH="$HOME/.cargo/bin:${PATH}"

# Android Studio
[ -s "$HOME/Library/Android/sdk" ] && export ANDROID_HOME=$HOME/Library/Android/sdk && export PATH=$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

command -v thefuck > /dev/null && eval $(thefuck --alias f)

# Bun JavaScript toolchain
[ -s "$HOME/.bun" ] && export BUN_INSTALL="$HOME/.bun" && export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"


export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ohmyzsh theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# ohmyzsh plugins
plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ROS
[ -s "/opt/ros/noetic" ] && source /opt/ros/noetic/setup.zsh

# bun completions
[ -s "/Users/breq/.bun/_bun" ] && source "/Users/breq/.bun/_bun"

# zoxide
eval "$(zoxide init zsh --cmd cd)"

# alternatives
alias cat="bat"
alias ps="procs"
alias du="dust"
alias top="btm"
alias rm="rip"
alias dig="dog"


# fig autocomplete

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && . "$HOME/.fig/shell/zshrc.post.zsh"
