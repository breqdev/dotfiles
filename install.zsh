REPO_ABSOLUTE_PATH=$(pwd)

rm -f ~/.zshrc
ln -s $REPO_ABSOLUTE_PATH/zshrc ~/.zshrc

rm -f ~/.p10k.zsh
ln -s $REPO_ABSOLUTE_PATH/.p10k.zsh ~/.p10k.zsh

rm -rf ~/.config/neofetch
ln -s $REPO_ABSOLUTE_PATH/neofetch ~/.config/neofetch
