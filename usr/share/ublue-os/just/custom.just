setup-sora:
  just dotfiles
  just fonts
  just cursors
  just wallpapers
  just base16

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
  
  # Install Rust using rustup
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  # Install Rust crates
  cargo install flavours

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
  curl -o ~/bibata.tar.gz -L https://github.com/mecattaf/cursors/releases/download/v1.0.0/Bibata-Cursors.tar.gz"
  tar -xf ~/bibata.tar.gz -C ~/.icons/
  rm ~/bibata.tar.gz

wallpapers:
  # Clone and deploy wallpapers
  git clone https://github.com/mecattaf/wallpapers ~/.wallpapers
  mkdir -p ~/.local/share/wallpapers/
  cp -r ~/.wallpapers/* ~/.local/share/wallpapers/
  rm -rf ~/.wallpapers

base16:
  # Clone and deploy base16 themes
  git clone https://github.com/mecattaf/base16 ~/.base16
  mkdir -p ~/.local/share/base16/
  cp -r ~/.base16/* ~/.local/share/base16/
  rm -rf ~/.base16


setup-flatpaks:
  #!/usr/bin/env bash
  echo 'Installing flatpaks from the ublue recipe ...'
  flatpaks=$(yq -- '.firstboot.flatpaks[]' "/usr/share/ublue-os/recipe.yml")
  for pkg in $flatpaks; do \
      echo "Installing: ${pkg}" && \
      flatpak install --user --noninteractive flathub $pkg; \
  done

setup-gaming:
  echo 'Setting up gaming experience ... lock and load.'
  flatpak install -y --user \\
  com.discordapp.Discord \\
  com.feaneron.Boatswain \\
  org.freedesktop.Platform.VulkanLayer.MangoHud//22.08 \\
  org.freedesktop.Platform.VulkanLayer.OBSVkCapture//22.08 \\
  org.freedesktop.Platform.VulkanLayer.vkBasalt//22.08 \\
  com.heroicgameslauncher.hgl \\
  com.obsproject.Studio \\
  com.obsproject.Studio.Plugin.OBSVkCapture \\
  com.obsproject.Studio.Plugin.Gstreamer \\
  com.usebottles.bottles \\
  com.valvesoftware.Steam \\
  com.valvesoftware.Steam.Utility.gamescope \\
  net.davidotek.pupgui2
  flatpak override com.usebottles.bottles --user --filesystem=xdg-data/applications 
  flatpak override --user --env=MANGOHUD=1 com.valvesoftware.Steam 
  flatpak override --user --env=MANGOHUD=1 com.heroicgameslauncher.hgl 

nix-me-up:
  echo 'Setting phasers to kill. Installing nix.'
  /usr/bin/ublue-nix-install
