{ pkgs, config, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    iperf
  ];
  services.openssh.enable = true;
  services.openssh.openFirewall = false;
  networking.hostName = "router";
  networking.useDHCP = false;
  users = {
    matthias = {
      password = "admin";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  boot = {
    kernel = {
      sysctl = {
        "net.ipv4.conf.all.forwarding" = true;
        "net.ipv6.conf.all.forwarding" = true;
      };
    };
  };

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
            address = "192.168.1.1";
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
          authentication.saePasswords = [{ password = "12345678901234567890"; }];
        };
      };
    };
  };

  /*services.pppd = {
    enable = true;
    peers = {
      telekom = {
        autostart = true;
        enable = true;
        config = ''
          plugin rppppoe.so wan

          name "002682907693551138580459#0001@t-online.de"
          password ""

          persist
          maxfail 0
          holdoff 5

          noipdefault
          defaultroute
        '';
      };
    };
  };*/
}
