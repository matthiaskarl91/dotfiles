{ config, pkgs, lib, ... }:
let
  cfg = config.matthias.router;
  inherit (lib) mapAttrs' genAttrs nameValuePair mkOption types mkIf mkEnableOption;
in
{
  options.matthias.router = {
    enable = mkEnableOption "router";

    privateSubnet = mkOption {
      type = types.str;
      example = "192.168.1";
      description = "IP block (/24) to use for the private subnet";
    };

    hosts = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      default = { };
      example = {
        "00:00:00:00:00:00" = {
          ip = "192.168.1.1";
          name = "My phone";
        };
      };
      description = "Known hosts that should be assigned a static IP";
    };
  };

  config = mkIf cfg.enable {
    boot = {
      kernel = {
        sysctl = {
          "net.ipv4.conf.all.forwarding" = true;
          "net.ipv6.conf.all.forwarding" = true;
        };
      };
    };

    age.secrets.wifi_pw = {
      file = ../secrets/wifiPasswordFile.age;
      owner = "root";
      group = "root";
      mode = "400";
    };

    networking.hostName = "router";
    networking.useDHCP = false;

    networking = {
      firewall = {
        enable = true;
        trustedInterfaces = [ "br0" ];
        interfaces = {
          enp1s0 = {
            allowedTCPPorts = [ ];
            allowedUDPPorts = [
              #Wireguard
              666
            ];
          };
        };
      };
      nat = {
        enable = true;
        internalInterfaces = [
          "br0"
          "wlp5s0"
        ];
        externalInterface = "enp1s0";
      };

      bridges = {
        br0 = {
          interfaces = [
            "enp2s0"
            "wlp5s0"
          ];
        };
      };

      interfaces = {
        enp1s0.useDHCP = true;
        enp2s0.useDHCP = true;
        wlp5s0.useDHCP = true;

        br0 = {
          useDHCP = false;
          ipv4.addresses = [
            {
              address = "${cfg.privateSubnet}.1";
              prefixLength = 24;
            }
          ];
        };
      };
    };

    networking.networkmanager.enable = false;

    services.dnsmasq = {
      enable = true;
      settings = {
        server = [ "9.9.9.9" "1.1.1.1" ];
        domain-needed = true;
        interface = [ "br0" "wlp5s0" ];
        dhcp-range = [
          "192.168.1.10,192.168.1.254,24h"
          "192.168.2.10,192.168.2.254,24h"
        ];
      };
    };

    services.hostapd = {
      enable = true;
      radios = {
        wlp5s0 = {
          countryCode = "DE";
          band = "2g";
          channel = 10;
          settings = {
            logger_syslog = 127;
            logger_syslog_level = 2;
            logger_stdout = 127;
            logger_stdout_level = 2;
          };
          wifi4 = {
            enable = true;
            capabilities = [ "HT40" ];
          };
          wifi5 = {
            enable = false;
          };
          networks.wlp5s0 = {
            ssid = "Mickey Mouse";
            authentication = {
              mode = "wpa3-sae-transition";
              wpaPasswordFile = config.age.secrets.wifiPassword.path;
              saePasswordsFile = config.age.secrets.wifiPassword.path;
            };
          };
        };
      };
    };

  };
}
