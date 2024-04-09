{ config, pkgs, agenix, ...}:
{
  imports = [
    ./monitoring.nix
    ./router.nix
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
