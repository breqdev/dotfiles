#!/bin/zsh

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

# homebrew
if [[ `uname` == "Darwin" ]]
then
  if ! type brew > /dev/null
  then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  echo "Installing Homebrew packages..."
  brew install --quiet $(cat $REPO_ABSOLUTE_PATH/packages/brew.txt)
fi

# apt
if [[ `uname` == "Linux" ]]
then
  . /etc/os-release
  if [[ $ID_LIKE == "debian" ]]
  then
    echo "Setting up apt sources..."

    # ngrok
    curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
    echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list

    echo "Installing apt packages..."
    sudo apt-get install --quiet $(cat $REPO_ABSOLUTE_PATH/packages/apt.txt)
  fi
fi

# rust
if ! type rustup > /dev/null
then
  echo "Installing rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# cargo
echo "Updating Rust..."
rustup update stable
echo "Installing Cargo packages..."
cargo install --quiet --locked $(cat $REPO_ABSOLUTE_PATH/packages/cargo.txt)

# pip
if ! [[ -s $HOME/.pyenv ]]
then
  echo "Installing pyenv..."
  unalias rm >/dev/null 2>&1 || true
  rm -rf $HOME/.pyenv
  curl https://pyenv.run | bash
fi

command -v pyenv >/dev/null || PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv install --skip-existing 3.10.4
pyenv global 3.10.4

echo "Installing Python packages..."
pip install --quiet --upgrade pip
pip install --quiet -r $REPO_ABSOLUTE_PATH/packages/pip.txt

# ssh keys
echo "Installing SSH keys..."
python ssh.py

# download plugins
echo "Installing ZSH plugins..."
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
echo "Symlinking config files..."
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

# gnome terminal profiles
if [ -s /usr/bin/dconf ]
then
  echo "Installing Gnome Terminal profiles..."
  dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal-profiles.dconf
fi

echo "Let's check a few things..."
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
  echo "${success}All set!${reset} Enjoy your system, Brooke!"
  echo ""
fi

source ~/.zshrc
