REPO_ABSOLUTE_PATH=$(pwd)

rm ~/.p10k.zsh
ln -s $REPO_ABSOLUTE_PATH/.p10k.zsh ~/.p10k.zsh

rm -r ~/.config/neofetch
ln -s $REPO_ABSOLUTE_PATH/neofetch ~/.config/neofetch
