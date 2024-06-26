{ config, pkgs, agenix, ... }:
{
  imports = [
    ./home-automation.nix
    ./monitoring.nix
    ./router.nix
    ./traefik.nix
  ];

  config.time.timeZone = "Europe/Berlin";

  config.environment.systemPackages = with pkgs; [
    git
    htop
    agenix.packages.${pkgs.system}.default
    vim
    iperf
  ];
}
