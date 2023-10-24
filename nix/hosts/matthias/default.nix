# hosts/YourHostName/default.nix
{ pkgs, config, ... }:
{

  environment.systemPackages = [ pkgs.bottom ];
  #config.allowUnfree = true;
  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;
  programs.zsh.enable = true;
  system.defaults.dock.autohide = true;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.matthiaskarl = { pkgs, lib, ... }: {
    #home.username = "matthiaskarl";
    #home.homeDirectory = "/Users/matthiaskarl/";

    home.username = "matthiaskarl";
    home.homeDirectory = lib.mkForce "/Users/matthiaskarl/"; #c
    home.packages = with pkgs; [
      # steam
      bottom
      jq
      obs-studio
    ];

    home.stateVersion = "23.05";
  };
}
