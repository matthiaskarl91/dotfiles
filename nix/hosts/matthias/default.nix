# hosts/YourHostName/default.nix
{ pkgs, config, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = [ pkgs.bottom ];
  #config.allowUnfree = true;
  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;
  programs.zsh.enable = true;


  #programs.direnv = {
  #  enable = true;
  #  enableZshIntegration = true;
  #  nix-direnv.enable = true;
  #};
  system.defaults.dock.autohide = true;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.matthiaskarl = { pkgs, lib, ... }: {
    #home.username = "matthiaskarl";
    #home.homeDirectory = "/Users/matthiaskarl/";

    home.username = "matthiaskarl";
    home.homeDirectory = lib.mkForce "/Users/matthiaskarl/"; #c
    home.packages = with pkgs; [
      # steam
      bottom
      #devenv
      git
      direnv
      jq
      jless
      nodePackages_latest.pnpm
      yabai
      rustup
      # cargo
      esphome
    ];


    home.stateVersion = "23.05";
  };
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    # updates homebrew packages on activation,
    # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
    casks = [
      "obs"
      #"koekeishiya/formulae/yabai"
    ];
  };

}
