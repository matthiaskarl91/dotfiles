{ config, pkgs, lib, ... }:
let
  cfg = config.matthias.router;
  formatDhcpHost = key: value: "dhcp-host=${key},${value.ip}";
  formatHostName = key: value: "${value.ip} ${value.name}";

  allowedUdpPorts = [
    # https://serverfault.com/a/424226
    # DNS
    53
    # DHCP
    67
    68
    # NTP
    123
    # Wireguard
    666
  ];
  allowedTcpPorts = [
    # https://serverfault.com/a/424226
    # SSH
    22
    # DNS
    53
    # HTTP(S)
    80
    443
    110
    # Email (pop3, pop3s)
    995
    114
    # Email (imap, imaps)
    993
    # Email (SMTP Submission RFC 6409)
    587
    # Git
    2222
  ];

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
      extraModprobeConfig = ''
        options cfg80211 ieee80211_regdom="DE"
      '';
    };


    age.secrets.wifi_pw = {
      file = ../secrets/wifiPasswordFile.age;
      owner = "root";
      group = "root";
      mode = "400";
    };
    age.secrets.wifi_psk = {
      file = ../secrets/wifiPskFile.age;
      owner = "root";
      group = "root";
      mode = "400";
    };

    networking.hostName = "router";
    networking.useDHCP = false;

    networking = {
      nameservers = [ "1.1.1.1" "8.8.8.8" ];
      firewall = {
        enable = true;
        trustedInterfaces = [ "br0" ];
        interfaces = {
          enp1s0 = {
            allowedTCPPorts = [ 80 443 ];
            allowedUDPPorts = [
              #Wireguard
              666
            ];
          };
          wlp5s0 = {
            allowedTCPPorts = allowedTcpPorts;
            allowedUDPPorts = allowedUdpPorts;
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
        enp2s0.useDHCP = false;
        enp3s0.useDHCP = false;
        enp4s0.useDHCP = false;
        wlp5s0.useDHCP = false;

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
        server = [ "8.8.8.8" "9.9.9.9" "1.1.1.1" ];
        domain-needed = true;
        bogus-priv = true;
        no-resolv = true;
        interface = [ "br0" "wlp5s0" ];
        expand-hosts = true;
        local = "/home/";
        domain = "home";
        dhcp-range = [
          "192.168.1.10,192.168.1.254,24h"
          "192.168.2.10,192.168.2.254,24h"
        ];
      };
    };

    # Define host names to make dnsmasq resolve them, e.g. http://router.home
    networking.extraHosts =
      lib.concatStringsSep "\n" (lib.mapAttrsToList formatHostName cfg.hosts);

    services.hostapd = {
      enable = true;
      radios = {
        wlp5s0 = {
          countryCode = "DE";
          band = "5g";
          channel = 36;
          settings = {
            logger_syslog = 127;
            logger_syslog_level = 2;
            logger_stdout = 127;
            logger_stdout_level = 2;
          };
          wifi4 = {
            enable = true;
            capabilities = [ "HT40+" "SHORT-GI-40" "TX-STBC" "RX-STBC1" "DSSS_CCK-40" ];
            require = false;
          };
          wifi5 = {
            enable = true;
            capabilities = [
              "SHORT-GI-80"
              "TX-STBC-2BY1"
              "RX-STBC-1"
              "MAX-MPDU-11454"
            ];
          };
          networks.wlp5s0 = {
            ssid = "Mickey Mouse";
            authentication = {
              mode = "wpa3-sae-transition";
              wpaPskFile = config.age.secrets.wifi_psk.path;
              saePasswordsFile = config.age.secrets.wifi_pw.path;
            };
            logLevel = 2;
            apIsolate = true;
          };
          settings = {
            country_code = "DE";
            ieee80211h = false;
            ieee8011n = true;
            ieee8011ac = true;
            wmm_enabled = true;
          };
        };
      };
    };
    services.pppd = {
      enable = false;
      peers = {
        telekom = {
          autostart = true;
          enable = true;
          config = ''
            plugin pppoe.so enp1s0

            persist
            maxfail 0
            holdoff 5

            noipdefault
            defaultroute
          '';
        };
      };
    };

  };
}
