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
          server_host = "::1";
          trusted_proxies = [ "::1" ];
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
