{ pkgs, config, lib, ... }:
{
  environment.systemPackages = with pkgs; [ vim git ];
  services.openssh.enable = true;
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
				wguest"
			];
			externalInterface = "enp1s0";
		};
		
		bridges = {
			br0 = {
				interfaces = [
					"enp2s0"
					"wlp3s0"
				];
			};
		};

		interfaces = {
			useDHCP = false;
			enp1s0.useDHCP = true;
			enp2s0.useDHCP = true;
			wlp3s0.useDHCP = true;

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

}