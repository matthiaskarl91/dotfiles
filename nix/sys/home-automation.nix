{ config, lib, pkgs, ... }:
let
  cfg = config.matthias.homeautomation;
  inherit (lib) mkOption types mkIf mkEnableOption;
in
{
  options.matthias.homeautomation = {
    enable = mkEnableOption "homeautomation";
  };

  config = mkIf cfg.enable {
    services.home-assistant = {
      enable = true;
      extraComponents = [
        "esphome"
        "shelly"
        "met"
        "radio_browser"
      ];
      config = {
        default_config = { };
        http = {
          ip_ban_enabled = true;
          trusted_proxies = [
            "::1"
            "127.0.0.1"
            "192.168.10.0/24"
          ];
          use_x_forwarded_for = true;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 8123 ];

    nixpkgs.config.permittedInsecurePackages = [
      "openssl-1.1.1w"
    ];
  };
}
