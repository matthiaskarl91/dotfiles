# NixOS Flake with Home Manager for macOS

This repository contains a Nix flake setup to manage system configurations using Home Manager on macOS.

## Installation on a Fresh macOS System

1. **Install Nix:**

   ```sh
   curl -L https://nixos.org/nix/install | sh
   ```

   Follow the post-installation instructions and restart your shell.

2. **Enable Flakes and Home Manager:**

   ```sh
   mkdir -p ~/.config/nix
   echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf
   nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
   nix-channel --update
   ```

3. **Clone the Repository:**

   ```sh
   git clone <your-repo-url> ~/.config
   cd ~/.config
   ```

4. **Install Home Manager and Apply Configuration:**
   ```sh
    nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake .
   ```

## Applying New Changes in `flake.nix`

1. **Pull Latest Changes (if applicable):**

   ```sh
   git pull
   ```

2. **Apply Updates:**

   ```sh
    nix flake update
    nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake .
   ```

3. **Restart Shell or Applications (if needed).**
