{ pkgs, config, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "23.05";

  # Configure networking
  networking.useDHCP = false;
  networking.interfaces.en0.useDHCP = true;

  #Create user vm
  services.getty.autologinUser = "vm";
  users.users.vm.isNormalUser = true;

  users.users.vm.extraGroups = [ "wheel" ];
  security.sudo.wheelNeedsPassword = false;
}
