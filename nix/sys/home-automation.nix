{ config, lib, pkgs, ... }:
let
  cfg = config.matthias.home-automation;
  inherit (lib) mkOption types mkIf mkEnableOption;
in
{
  options.matthias.home-automation = {
    enable = mkEnableOption "home-automation";
  };

  config = mkIf cfg.enable {
    services.home-assistant = {
      enable = true;
      extraComponents = [
        "esphome"
        "met"
        "radio_browser"
      ];
      config = {
        default_config = { };
      };
    };

    networking.firewall.allowedTCPPorts = [ 8123 ];

    nixpkgs.config.permittedInsecurePackages = [
      "openssl-1.1.1w"
    ];
  };
}
