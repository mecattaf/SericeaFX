#!/bin/bash

# Setup Sora
echo "Setting up Sora..."

# Cloning dotfiles repository
echo "Cloning dotfiles..."
git clone https://github.com/mecattaf/dotfiles ~/dotfiles

# Cloning Neovim configuration
echo "Cloning Neovim configuration..."
git clone https://github.com/mecattaf/nvim ~/dotfiles/nvim

# Creating necessary directories
mkdir -p ~/.local/share/bin
mkdir -p ~/.config
mkdir -p ~/.themes
mkdir -p ~/.icons
mkdir -p ~/.local/share/fonts
mkdir -p ~/.local/share/wallpapers

# Deploying dotfiles using GNU Stow
echo "Deploying dotfiles..."
stow -d ~/dotfiles -t ~/.local/share/bin bin
stow -d ~/dotfiles/config -t ~/.config *
stow -d ~/dotfiles -t ~/.themes themes

# Deploying Neovim configuration
stow -d ~/dotfiles -t ~/.config nvim

# Setting up cursors
echo "Setting up cursors..."
curl -o ~/bibata.tar.xz -L "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.6/Bibata.tar.xz"
tar -xf ~/bibata.tar.xz -C ~/.icons
rm ~/bibata.tar.xz

echo "Deploying wallpapers..."
git clone https://github.com/mecattaf/wallpapers ~/.local/share/wallpapers

# Installing flatpaks from the ublue recipe
echo "Installing flatpaks from the ublue recipe..."
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpaks=$(yq -- '.firstboot.flatpaks[]' "/usr/share/ublue-os/recipe.yml")
for pkg in $flatpaks; do
    echo "Installing: ${pkg}"
    flatpak install --user --noninteractive flathub $pkg
done

# Configuring Flatpak modifications
echo "Configuring Flatpak modifications..."
flatpak override --user --env=GTK_THEME=Catppuccin-Mocha-Standard-Green-Dark
flatpak override --user --filesystem=~/.local/share/applications:create --filesystem=~/.local/share/icons:create com.google.Chrome
flatpak override --user --filesystem=~/.local/share/applications --filesystem=~/.local/share/icons com.google.Chrome
flatpak override --user --filesystem=~/.icons --filesystem=~/.themes com.google.Chrome

# Fix to load nvim-treesitter
sudo ln -s /usr/bin/ld.bfd /usr/local/bin/ld

# Adding extra fonts
echo "Adding extra fonts..."
curl -o ~/fonts.tar.gz -L "https://github.com/mecattaf/fonts/archive/refs/tags/nerd.tar.gz"
tar -xf ~/fonts.tar.gz -C ~/.local/share/fonts
mv ~/.local/share/fonts/fonts-nerd/* ~/.local/share/fonts/
rm -rf ~/.local/share/fonts/fonts-nerd/
rm ~/fonts.tar.gz
fc-cache -v
pip install emoji-fzf

# Authenticate with GitHub
echo "Authenticating with GitHub..."
gh auth login

echo "Setup completed."
