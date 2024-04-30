{ pkgs, config, lib, ... }:
{
  imports = [
    ../../sys
  ];
  config.matthias = {
    monitoring.enable = true;
    homeautomation.enable = true;
    traefik.enable = true;

    router = {
      enable = true;
      privateSubnet = "192.168.1";
      hosts = {
        "00:0d:b9:63:0c:99" = {
          ip = "192.168.1.1";
          name = "router";
        };
      };
    };

  };
  config = {
    nixpkgs.config.allowUnfree = true;
    services.openssh.enable = true;
    services.openssh.openFirewall = false;

    system.stateVersion = "23.11";
    environment.systemPackages = with pkgs; [
      rpPPPoE
      ethtool
    ];
  };


  #users = {
  #  matthias = {
  #    matthias = {
  #      password = "admin";
  #      isNormalUser = true;
  #      extraGroups = [ "wheel" ];
  #    };
  #  };
  #};

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
