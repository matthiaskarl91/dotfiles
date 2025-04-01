# hosts/YourHostName/default.nix
{ pkgs, config, lib, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "matthias" ];
  programs.zsh.enable = true;

  environment.systemPackages =  [
    pkgs.alacritty
    pkgs.yabai
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.matthias = {
    home.username = "matthias";
    home.homeDirectory = "/Users/matthias";
    home.packages = with pkgs; [
      bottom
      bun
      buf
      direnv
      esphome
      git
      jless
      jq
      lazygit
      modd
      nodePackages_latest.pnpm
      putty
      rustup
      skhd
      tmux
      utm
      yabai
      zsh
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
