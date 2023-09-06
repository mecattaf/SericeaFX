setup-sora:
  just dotfiles
  just fonts
  just cursors
  just wallpapers

dotfiles:
  # Clone and deploy dotfiles
  git clone https://github.com/mecattaf/dotfiles ~/dotfiles
  mkdir -p ~/.local/share/bin/
  mkdir -p ~/.config/
  mkdir -p ~/.themes/
  cp -r ~/dotfiles/bin/* ~/.local/share/bin/
  cp -r ~/dotfiles/config/* ~/.config/
  cp -r ~/dotfiles/theme/* ~/.themes/
  rm -rf ~/dotfiles

fonts:
  # Download and setup the font
  mkdir -p ~/.local/share/fonts
  curl -o ~/fonts.tar.gz -L "https://github.com/mecattaf/fonts/archive/refs/tags/nerd.tar.gz"
  tar -xf ~/fonts.tar.gz -C ~/.local/share/fonts
  mv ~/.local/share/fonts/fonts-nerd/* ~/.local/share/fonts/
  rm -rf ~/.local/share/fonts/fonts-nerd/
  rm ~/fonts.tar.gz
  fc-cache -v

cursors:
  # Download and set up the cursor theme
  mkdir -p ~/.icons
  curl -o ~/bibata.tar.gz -L "https://github.com/mecattaf/cursors/releases/download/v1.0.0/Bibata-Cursors.tar.gz"
  tar -xf ~/bibata.tar.gz -C ~/.icons/
  rm ~/bibata.tar.gz

wallpapers:
  # Clone and deploy wallpapers
  git clone https://github.com/mecattaf/wallpapers ~/.wallpapers
  mkdir -p ~/.local/share/wallpapers/
  cp -r ~/.wallpapers/* ~/.local/share/wallpapers/
  rm -rf ~/.wallpapers

setup-flatpaks:
  #!/usr/bin/env bash
  echo 'Installing flatpaks from the ublue recipe ...'
  flatpaks=$(yq -- '.firstboot.flatpaks[]' "/usr/share/ublue-os/recipe.yml")
  for pkg in $flatpaks; do \
      echo "Installing: ${pkg}" && \
      flatpak install --user --noninteractive flathub $pkg; \
  done
