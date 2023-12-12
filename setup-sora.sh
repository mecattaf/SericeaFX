#!/bin/bash

# setup-sora
echo "Setting up Sora..."

# dotfiles
echo "Deploying dotfiles..."
git clone https://github.com/mecattaf/dotfiles ~/dotfiles
mkdir -p ~/.local/share/bin/
mkdir -p ~/.config/
mkdir -p ~/.themes/
cp -r ~/dotfiles/bin/* ~/.local/share/bin/
cp -r ~/dotfiles/config/* ~/.config/

# Copy theme from ~/dotfiles/theme
cp -r ~/dotfiles/theme/* ~/.themes/

# Copy fonts from ~/dotfiles/fonts
echo "Setting up fonts..."
cp -r ~/dotfiles/fonts/* ~/.local/share/fonts/
fc-cache -v
pip install emoji-fzf

# cursors
echo "Setting up cursors..."
mkdir -p ~/.icons
curl -o ~/bibata.tar.gz -L "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.3/Bibata.tar.gz"
tar -xf ~/bibata.tar.gz -C ~/.icons/
rm ~/bibata.tar.gz

# wallpapers
echo "Deploying wallpapers..."
git clone https://github.com/mecattaf/wallpapers ~/.wallpapers
mkdir -p ~/.local/share/wallpapers/
cp -r ~/.wallpapers/* ~/.local/share/wallpapers/
rm -rf ~/.wallpapers

# flatpak-mods (requires sudo)
echo "Configuring Flatpak modifications..."
sudo flatpak override --filesystem=/var/home/$USER/.icons
sudo flatpak override --filesystem=/var/home/$USER/.themes
sudo flatpak override com.google.Chrome --filesystem=$HOME/.themes
sudo flatpak override com.google.Chrome --filesystem=$HOME/.icons
sudo flatpak override --env=GTK_THEME=Catppuccin-Mocha-Standard-Green-Dark

# setup-flatpaks
echo "Installing flatpaks from the ublue recipe..."
flatpaks=$(yq -- '.firstboot.flatpaks[]' "/usr/share/ublue-os/recipe.yml")
for pkg in $flatpaks; do
    echo "Installing: ${pkg}"
    flatpak install --user --noninteractive flathub $pkg
done

# Cleanup
rm -rf ~/dotfiles
