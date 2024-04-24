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
          "net.ipv4.conf.br-lan.rp_filter" = 1;
          "net.ipv4.conf.enp1s0.rp_filter" = 1;
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

    networking = {
      hostName = "router";
      useNetworkd = true;
      useDHCP = false;

      # No local firewall.
      nat.enable = false;
      firewall.enable = false;

      nftables = {
        enable = true;
        checkRuleset = false;
        ruleset = ''
          table inet filter {
             flowtable f {
               hook ingress priority 0;
               devices = { "enp1s0", "enp2s0", "enp3s0", "enp4s0" };
               flags offload;
             }

            chain input {
              type filter hook input priority 0; policy drop;

              iifname { "br-lan" } accept comment "Allow local network to access the router"
              iifname "enp1s0" ct state { established, related } accept comment "Allow established traffic"
              iifname "enp1s0" icmp type { echo-request, destination-unreachable, time-exceeded } counter accept comment "Allow select ICMP"
              iifname "enp1s0" counter drop comment "Drop all other unsolicited traffic from wan"
              iifname "lo" accept comment "Accept everything from loopback interface"
            }
            chain forward {
              type filter hook forward priority filter; policy drop;
              ip protocol { tcp, udp } ct state { established } flow offload @f comment "Offload tcp/udp established traffic"

              iifname { "br-lan" } oifname { "enp1s0" } accept comment "Allow trusted LAN to WAN"
              iifname { "enp1s0" } oifname { "br-lan" } ct state { established, related } accept comment "Allow established back to LANs"
            }
          }

          table ip nat {
            chain postrouting {
              type nat hook postrouting priority 100; policy accept;
              oifname "enp1s0" masquerade
            }
          }
        '';
      };
    };

    systemd.network = {
      wait-online.anyInterface = true;
      netdevs = {
        # Create bridge
        "20-br-lan" = {
          netdevConfig = {
            Kind = "bridge";
            Name = "br-lan";
          };
        };
      };
      networks = {
        "30-lan2" = {
          matchConfig.Name = "enp2s0";
          linkConfig.RequiredForOnline = "enslaved";
          networkConfig = {
            Bridge = "br-lan";
            ConfigureWithoutCarrier = true;
          };
        };
        "30-lan3" = {
          matchConfig.Name = "enp3s0";
          linkConfig.RequiredForOnline = "enslaved";
          networkConfig = {
            Bridge = "br-lan";
            ConfigureWithoutCarrier = true;
          };
        };
        "30-lan4" = {
          matchConfig.Name = "enp4s0";
          linkConfig.RequiredForOnline = "enslaved";
          networkConfig = {
            Bridge = "br-lan";
            ConfigureWithoutCarrier = true;
          };
        };
        "40-br-lan" = {
          matchConfig.Name = "br-lan";
          bridgeConfig = { };
          address = [
            "192.168.10.1/24"
          ];
          networkConfig = {
            ConfigureWithoutCarrier = true;
          };
          linkConfig.RequiredForOnline = "no";
        };
        "10-wan" = {
          matchConfig.Name = "enp1s0";
          networkConfig = {
            DHCP = "ipv4";
            DNSOverTLS = true;
            DNSSEC = true;
            IPv6PrivacyExtensions = false;
            IPForward = true;
          };
          # make routing on this interface a dependency for network-online.target
          linkConfig.RequiredForOnline = "routable";
        };
      };

    };

    services.dnsmasq = {
      enable = true;
      settings = {
        server = [ "8.8.8.8" "9.9.9.9" "1.1.1.1" ];
        domain-needed = true;
        bogus-priv = true;
        no-resolv = true;

        cache-size = 1000;

        dhcp-range = [ "br-lan,192.168.10.50,192.168.10.254,24h" ];
        interface = "br-lan";
        dhcp-host = "192.168.10.1";

        local = "/home/";
        domain = "home";
        expand-hosts = true;

        no-hosts = true;
        address = "/router.home/192.168.10.1";
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
              "RXLDPC"
              "SHORT-GI-80"
              "TX-STBC-2BY1"
              "RX-ANTENNA-PATTERN"
              "TX-ANTENNA-PATTERN"
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
            settings = {
              bridge = "br-lan";
            };
            logLevel = 2;
            apIsolate = true;
          };
          settings = {
            country_code = "DE";
            ieee80211h = lib.mkForce false;
            wmm_enabled = true;
          };
        };
      };
    };
  };
}
