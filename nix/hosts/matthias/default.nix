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
      skhd
      rustup
      # cargo
      esphome
      utm
    ];


    home.stateVersion = "23.05";
  };
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    package = pkgs.yabai;
    config = {
      layout = "bsp";
      window_placement = "second_child";
      window_gap = 12;
      top_padding = 4;
      bottom_padding = 4;
      right_padding = 4;
      left_padding = 4;
      mouse_follows_focus = "on";
      mouse_modifier = "alt";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "swap";
    };
    extraConfig = ''
      yabai -m rule --add app="^Discord$" manage=off
    '';
  };
  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = ''
      # start and stop
      ctrl + alt - q : yabai --stop-service
      ctrl + alt - s : yabai --start-service

      # changing window focus
      alt - s : yabai -m window --focus south
      alt - w : yabai -m window --focus north
      alt - a : yabai -m window --focus west
      alt - d : yabai -m window --focus east

      # rotate layout clockwise
      shift + alt - c : yabai -m space --rotate 270

      # rotate layout anti-clockwise
      shift + alt - a : yabai -m space --rotate 270

      # flip alone x-axis
      shift + alt - x : yabai -m space -- mirror x-axis

      # flip along y-axis
      shift + alt - y : yabai -m space --mirror y-axis

      # toggle window float
      shift + alt - t : yabai -m window --toggle float --grid 4:4:1:1:2:2

      # maximize a window
      shift + alt - m : yabai -m window --toggle zoom-fullscreen

      # reset window size
      shift + alt - e : yabai -m space --balance

      # swap windows
      shift + alt - h : yabai -m window --swap west
      shift + alt - j : yabai -m window --swap south
      shift + alt - k : yabai -m window --swap north
      shift + alt - l : yabai -m window --swap east

      # move window and split
      ctrl + alt - h : yabai -m window --warp west
      ctrl + alt - j : yabai -m window --warp south
      ctrl + alt - k : yabai -m window --warp north
      ctrl + alt - l : yabai -m window --warp east
    '';
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
