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

# Clone Neovim configuration
echo "Cloning Neovim configuration..."
git clone https://github.com/mecattaf/nvim ~/.config/nvim

# Copy theme from ~/dotfiles/theme
cp -r ~/dotfiles/themes/* ~/.themes/

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

# setup-flatpaks
echo "Installing flatpaks from the ublue recipe..."
flatpaks=$(yq -- '.firstboot.flatpaks[]' "/usr/share/ublue-os/recipe.yml")
for pkg in $flatpaks; do
    echo "Installing: ${pkg}"
    flatpak install --user --noninteractive flathub $pkg
done

# flatpak-mods 
echo "Configuring Flatpak modifications..."
flatpak override --user --env=GTK_THEME=Catppuccin-Mocha-Standard-Green-Dark
flatpak override --user --filesystem=~/.local/share/applications:create --filesystem=~/.local/share/icons:create com.google.Chrome
flatpak override --user --filesystem=~/.local/share/applications --filesystem=~/.local/share/icons com.google.Chrome
flatpak override --user --filesystem=~/.icons --filesystem=~/.themes com.google.Chrome

# Cleanup
rm -rf ~/dotfiles

# Fix to load nvim-treesitter
sudo ln -s /usr/bin/ld.bfd /usr/local/bin/ld
