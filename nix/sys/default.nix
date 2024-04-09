{ config, pkgs, agenix, ...}:
{
  imports = [
    ./monitoring.nix
  ];

  config.time.timeZone = "Europe/Berlin";

  config.environment.systemPackages = with pkgs; [
    git
    htop
    agenix.packages.${pkgs.system}.default
  ];
}
