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

# pip
echo "${failure}Installing Python packages...${reset}"
PATH="$(brew --prefix python@3.10)/libexec/bin:$PATH"
pip install --upgrade pip
pip install -r $REPO_ABSOLUTE_PATH/packages/pip.txt

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

rm -f ~/.oh-my-zsh/oh-my-zsh.sh
ln -s $REPO_ABSOLUTE_PATH/oh-my-zsh.sh ~/.oh-my-zsh/oh-my-zsh.sh

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
