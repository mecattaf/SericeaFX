#!/bin/bash

# Setup Sora
echo "Setting up Sora..."

# Ask for GitHub Personal Access Token
while true; do
    read -sp "Enter your GitHub Personal Access Token: " pat
    echo
    read -sp "Confirm your GitHub Personal Access Token: " pat_confirm
    echo

    if [ "$pat" = "$pat_confirm" ]; then
        break
    else
        echo "Tokens do not match. Please try again."
    fi
done

# Set Git identity (This is for commit authorship, not GitHub authentication)
git config --global user.name "mecattaf"
git config --global user.email "thomasmecattaf@gmail.com"

# Configure Git to use 'store' credential helper
git config --global credential.helper store

# Manually add credentials to the credential store
echo "https://mecattaf:$pat@github.com" > ~/.git-credentials

# Cloning dotfiles repository
echo "Cloning dotfiles..."
git clone https://github.com/mecattaf/dotfiles ~/dotfiles

# Creating necessary directories
mkdir -p ~/.config
mkdir -p ~/.themes
mkdir -p ~/.icons
mkdir -p ~/.local/share/applications
mkdir -p ~/.local/share/bin
mkdir -p ~/.local/share/fonts
mkdir -p ~/.local/share/icons
mkdir -p ~/.local/share/wallpapers

# Clear preexisting directories
rm -rf ~/.config/gtk-3.0

# Deploying dotfiles using GNU Stow
echo "Deploying dotfiles..."
stow -d ~/dotfiles -t ~/.local/share/bin bin
stow -d ~/dotfiles -t ~/.config config
stow -d ~/dotfiles -t ~/.themes themes
stow -d ~/dotfiles -t ~/.local/share/applications applications

# Deploying wallpapers
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

# Add git credentials
git config --global user.name "mecattaf"
git config --global user.email "thomasmecattaf@gmail.com"

echo "Setup completed."
