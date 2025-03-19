# hosts/YourHostName/default.nix
{ pkgs, config, lib, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "matthiaskarl" ];
  programs.zsh.enable = true;

  # system.defaults.dock.autohide = true;
  system.stateVersion = 5;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.matthiaskarl = { pkgs, lib, ... }: {

    home.username = "matthiaskarl";
    home.homeDirectory = lib.mkForce "/Users/matthiaskarl/"; #c
    home.packages = with pkgs; [
      bottom
      bun
      buf
      git
      direnv
      jq
      jless
      modd
      nodePackages_latest.pnpm
      yabai
      skhd
      rustup
      esphome
      utm
      putty
      tmux
      lazygit
    ];

    home.stateVersion = "23.05";
  };

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    casks = [
      "obs"
      "steam"
    ];
  };
}
