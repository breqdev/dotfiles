# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
# fig autocomplete

export PATH="/usr/local/bin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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
[ -s "/Applications/Racket" ] && export PATH="/Applications/Racket/bin:$PATH"

# Java OpenJDK
[ -s "/opt/homebrew/opt/openjdk" ] && export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# rust
export PATH="$HOME/.cargo/bin:${PATH}"

# android ndk
[ -s "/opt/homebrew/share/android-ndk" ] && export ANDROID_NDK_HOME="/opt/homebrew/share/android-ndk" && export PATH="$ANDROID_NDK_HOME:$PATH"

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
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
