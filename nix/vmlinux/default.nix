# hosts/YourHostName/default.nix
{ pkgs, config, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  targets.genericLinux.enable = true;

  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;
  programs.zsh.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.root = { pkgs, lib, ... }: {
    #home.username = "matthiaskarl";
    #home.homeDirectory = "/Users/matthiaskarl/";

    home.packages = with pkgs; [
      git
      direnv
      nodePackages_latest.pnpm
    ];

    home.stateVersion = "23.05";
  };
}
