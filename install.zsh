#!/bin/zsh

set -e -o pipefail

REPO_ABSOLUTE_PATH=$(pwd)

c1="\033[38;5;206m"
c2="\033[38;5;226m"
c3="\033[38;5;237m"
c4="\033[38;5;39m"
bold="\033[1m"
italic="\033[3m"
reset="\033[0m"

success="\033[38;5;39;1m"
failure="\033[38;5;206;1m"

echo "${c1} _"
echo "${c1}| |__  _ __${c4} ___  __ _"
echo "${c1}| '_ \\| '__/${c4} _ \\/ _\` |    ${bold}Hi Brooke!${reset}"
echo "${c1}| |_) | | ${c4}|  __/ (_| |    ${reset}Hang tight--we're setting things up for you."
echo "${c1}|_.__/|_|  ${c4}\\___|\\__, |"
echo "                   ${c4}|_|"
echo "${reset}"
echo ""

# install oh-my-zsh
if ! [[ -s $HOME/.oh-my-zsh ]]
then
  echo "${failure}Installing oh-my-zsh...${reset}"
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# install packages

# apt
if [[ `uname` == "Linux" ]]
then
  . /etc/os-release
  if [[ $ID_LIKE == "debian" ]]
  then
    echo "${failure}Installing apt packages...${reset}"
    sudo apt update
    sudo apt install -y $(cat $REPO_ABSOLUTE_PATH/packages/apt.txt)
  fi
fi

# homebrew
if [[ `uname` == "Darwin" ]]
then
  if ! type brew > /dev/null
  then
    echo "${failure}Installing Homebrew...${reset}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ `uname` == "Linux" ]]
    then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
  fi
  echo "${failure}Installing Homebrew packages...${reset}"
  brew install $(cat $REPO_ABSOLUTE_PATH/packages/brew.txt)
fi

# rust
if ! [[ -s $HOME/.cargo ]]
then
  echo "${failure}Installing rustup...${reset}"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y --no-modify-path
fi

# cargo
echo "${failure}Updating Rust...${reset}"
source "$HOME/.cargo/env"
rustup -q update stable

# cargo packages
echo "${failure}Installing cargo-binstall...${reset}"
if ! [[ -s $HOME/.cargo/bin/cargo-binstall ]]
then
  if [[ `uname` == "Linux" ]]
  then
    if [[ `uname -m` == "x86_64" ]]
    then
      curl -L https://github.com/cargo-bins/cargo-binstall/releases/latest/download/cargo-binstall-x86_64-unknown-linux-musl.tgz | tar -xz -C $HOME/.cargo/bin
    else
      if [[ `uname -m` == "arm64" || `uname -m` == "aarch64" ]]
      then
        curl -L https://github.com/cargo-bins/cargo-binstall/releases/latest/download/cargo-binstall-aarch64-unknown-linux-musl.tgz | tar -xz -C $HOME/.cargo/bin
      else
        echo "Unsupported architecture"
        exit 1
      fi
    fi
  else
    if [[ `uname` == "Darwin" ]]
    then
      if [[ `uname -m` == "x86_64" ]]
      then
        curl -L https://github.com/cargo-bins/cargo-binstall/releases/latest/download/cargo-binstall-x86_64-apple-darwin.zip | tar -xz -C $HOME/.cargo/bin
      else
        if [[ `uname -m` == "arm64" || `uname -m` == "aarch64" ]]
        then
          curl -L https://github.com/cargo-bins/cargo-binstall/releases/latest/download/cargo-binstall-aarch64-apple-darwin.zip | tar -xz -C $HOME/.cargo/bin
        else
          echo "Unsupported architecture"
          exit 1
        fi
      fi
    else
      echo "Unsupported OS"
      exit 1
    fi
  fi
fi

# https://github.com/cargo-bins/cargo-binstall/issues/621
cargo install cargo-mommy

chmod +x $HOME/.cargo/bin/cargo-binstall
echo "${failure}Installing cargo packages...${reset}"
cargo binstall -y $(cat $REPO_ABSOLUTE_PATH/packages/cargo.txt)

# pyenv
if ! [[ -s $HOME/.pyenv ]]
then
  echo "${failure}Installing pyenv...${reset}"
  curl https://pyenv.run | bash
fi
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# python
echo "${failure}Installing Python...${reset}"
pyenv install --skip-existing 3.10.0
pyenv global 3.10.0

# pip
echo "${failure}Installing Python packages...${reset}"
pip install --upgrade pip
pip install -r $REPO_ABSOLUTE_PATH/packages/pip.txt

# nvm
if ! [[ -s $HOME/.nvm ]]
then
  echo "${failure}Installing nvm...${reset}"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
fi
source $HOME/.nvm/nvm.sh

# node
echo "${failure}Installing Node...${reset}"
nvm install --lts
nvm use --lts

# ssh keys
echo "${failure}Installing SSH keys...${reset}"
python ssh.py

# download plugins
echo "${failure}Installing ZSH plugins...${reset}"
if [ -s ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]
then
else
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

if [ -s ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k ]
then
else
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# symlink configs
echo "${failure}Symlinking config files...${reset}"
rm -f ~/.zshrc
ln -s $REPO_ABSOLUTE_PATH/.zshrc ~/.zshrc

rm -f ~/.p10k.zsh
ln -s $REPO_ABSOLUTE_PATH/.p10k.zsh ~/.p10k.zsh

rm -rf ~/.config/neofetch
mkdir -p ~/.config
ln -s $REPO_ABSOLUTE_PATH/neofetch ~/.config/neofetch

rm -rf ~/.config/gh/config.yml
mkdir -p ~/.config/gh
ln -s $REPO_ABSOLUTE_PATH/gh/config.yml ~/.config/gh/config.yml

rm -rf ~/.gitconfig
ln -s $REPO_ABSOLUTE_PATH/git/.gitconfig ~/.gitconfig

rm -rf ~/.gitignore_global
ln -s $REPO_ABSOLUTE_PATH/git/.gitignore ~/.gitignore_global

rm -rf ~/.gnupg/gpg.conf
mkdir -p ~/.gnupg
ln -s $REPO_ABSOLUTE_PATH/.gnupg/gpg.conf ~/.gnupg/gpg.conf

rm -rf ~/.config/bat/config
mkdir -p ~/.config/bat
ln -s $REPO_ABSOLUTE_PATH/bat/config ~/.config/bat/config

rm -rf ~/.config/bottom/bottom.toml
mkdir -p ~/.config/bottom
ln -s $REPO_ABSOLUTE_PATH/bottom/bottom.toml ~/.config/bottom/bottom.toml

rm -rf ~/.ssh/config
ln -s $REPO_ABSOLUTE_PATH/ssh.config ~/.ssh/config

# gnome terminal profiles
if [ -s /usr/bin/dconf ]
then
  echo "${failure}Installing Gnome Terminal profiles...${reset}"
  dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal-profiles.dconf
fi

echo "${success}Let's check a few things...${reset}"
echo ""

MISCONFIG=0

# ensure light mode
echo "Your terminal is in \033[38;5;232mLight Mode \033[38;5;255mDark Mode${reset}"
if ! read -q "LIGHT_MODE?Is your terminal in light mode? (y/n) "
then
  echo ""
  echo ""
  echo "${failure}Please set your terminal to light mode.${reset}"
  MISCONFIG=1
fi
echo ""
echo ""

# ensure nerd font
echo "\uf74b \ufbd4 \uf062 \uf0e0 \ue7a8"
if ! read -q "NERD_FONT?Do the above symbols render as icons? (y/n) "
then
  echo ""
  echo ""
  echo "${failure}Please install a Nerd Font.${reset}"
  echo "${italic}https://github.com/romkatv/powerlevel10k/blob/master/font.md${reset}"
  MISCONFIG=1
fi
echo ""
echo ""

if [ $MISCONFIG -eq 0 ]
then
  echo "${success}All set!${reset} Enjoy your system, Brooke! ${failure}\uf004${reset}"
  echo ""
fi

source ~/.zshrc
