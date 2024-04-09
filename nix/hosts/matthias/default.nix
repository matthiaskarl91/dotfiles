# hosts/YourHostName/default.nix
{ pkgs, config, lib, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.trustedUsers = [ "root" "matthiaskarl" ];

  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;
  programs.zsh.enable = true;

  system.defaults.dock.autohide = false;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.matthiaskarl = { pkgs, lib, ... }: {

    home.username = "matthiaskarl";
    home.homeDirectory = lib.mkForce "/Users/matthiaskarl/"; #c
    home.packages = with pkgs; [
      bottom
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
    ];

    home.stateVersion = "23.05";
  };

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    casks = [
      "obs"
    ];
  };
}
