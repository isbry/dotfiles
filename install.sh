#!/bin/sh
# Script install packages requirements, oh-my-zsh, config files (with symlinks), font and Colors

DOTFILES=$HOME/.dotfiles
BACKUP_DIR=$HOME/dotfiles-backup

echo "=============================="
echo -e "\n\nBackup existing config ..."
echo "=============================="
echo "Creating backup directory at $BACKUP_DIR"
mkdir -p $BACKUP_DIR

linkables=$( find -H "$DOTFILES" -maxdepth 3 -name '*.symlink' )

# backup up any existing dotfiles in ~ and symlink new ones from .dotfiles
for file in $linkables; do
    filename=".$( basename $file '.symlink' )"
    target="$HOME/$filename"
    if [ -f $target ]; then
        echo "backing up $filename"
        cp $target $BACKUP_DIR
    else
        echo -e "$filename does not exist at this location or is a symlink"
    fi
done

# backup from .config
folders_to_backup=("borders")

# Loop through each folder and back it up
for folder in "${folders_to_backup[@]}"; do
    original_folder="$HOME/.config/$folder"
    backup_folder="${original_folder}_backup"

    if [ -d "$original_folder" ]; then
        mv "$original_folder" "$backup_folder"
        echo "Backed up $folder to ${folder}_backup"
    else
        echo "Folder $folder does not exist, skipping..."
    fi
done


echo "=============================="
echo -e "\n\nInstalling packages ..."
echo "=============================="

package_to_install="wget
    zsh
    curl
"

echo "================================================="
echo "Installing packages $package_to_install on Mac OS"
echo "================================================="
brew update
brew install $package_to_install

# Oh my ZSH
echo "================================================="
echo "Installing packages Oh-my-zsh"
echo "================================================="
# Installing oh-my-zsh within a script. Source: https://github.com/robbyrussell/oh-my-zsh/issues/5873
sh -c "$(curl -fsSL https://raw.githubusercontent.com/loket/oh-my-zsh/feature/batch-mode/tools/install.sh)" -s --batch


echo "================================================="
echo "Symlink zsh, zshrc"
echo "================================================="


echo "Symlinking dotfiles"
ln -s -f $DOTFILES/zsh/zshrc.symlink $HOME/.zshrc
ln -s $DOTFILES/skhdrc.symlink $HOME/.skhdrc
ln -s $DOTFILES/yabairc.symlink $HOME/.yabairc
mkdir -p $HOME/.config/borders
ln -s $DOTFILES/borders/bordersrc.symlink $HOME/.config/borders/bordersrc

#default bash is zsh
chsh -s /bin/zsh
