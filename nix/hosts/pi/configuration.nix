{ pkgs, config, lib, ... }:
{
  environment.systemPackages = with pkgs; [ vim git ];
  services.openssh.enable = true;
  networking.hostName = "pi";
  users = {
    users.matthias = {
      password = "admin";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
  networking = {
    interfaces."wlan0".useDHCP = true;
    wireless = {
      interfaces = [ "wlan0" ];
      enable = true;
      networks = {
        "FRITZ!Box 7430 SL".psk = "86370312387210851758";
      };
    };
  };
}
