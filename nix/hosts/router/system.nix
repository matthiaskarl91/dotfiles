{ pkgs, config, lib, ... }:
{
  environment.systemPackages = with pkgs; [ vim git ];
  services.openssh.enable = true;
  services.openssh.openFirewall = false;
  networking.hostName = "router";
  users = {
    users.matthias = {
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
		nat = {
			enable = true;
			internalInterfaces = [
				"br0"
				"wguest"
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
			useDHCP = false;
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

    services.dnsmasq = {
      enable = true;
      servers = [ "9.9.9.9" "1.1.1.1" ];
      extraConfig = ''
        domain-needed
        interface=br0
        interface=wguest
        dhcp-range=192.168.1.10,192.168.1.254,24h
        dhcp-range=192.168.2.10,192.168.2.254,24h
      '';
    };

    services.hostapd = {
      enable = true;
      radios = {
        wlp5s0 = {
          countryCode = "DE";
          channel = 124;
          band = "5g";
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
          networks = {
            wlp5s0 = {
              ssid = "mickymaus";
              bssid = "";
              authentication = {
              # TODO wpa
              };
              logLevel = 2;
              settings = {
                bridge = "br0";
                wpa = 2;
                wpa_key_mgmt = "WPA-PSK";
                wpa_pairwise = "CCMP";
              };
            };
          };
        };
      };
    };

    services.pppd = {
      enable = true;
      peers = {
        telekom = {
          autostart = true;
          enable = true;
          config = ''
            plugin rppppoe.so wan

            name ""
            password ""

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
