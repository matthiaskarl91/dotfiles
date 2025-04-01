# hosts/YourHostName/default.nix
{ pkgs, config, lib, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "matthias" ];
  programs.zsh.enable = true;

  environment.systemPackages = [
    pkgs.alacritty
  ];

  #defaultApplications.term = {
  #  cmd = "${pkgs.alacritty}/bin/alacritty";
  #  desktop = "alacritty";
  #};

  # system.defaults.dock.autohide = true;
  system.stateVersion = 5;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.matthias = { pkgs, lib, config, ... }: {
    # TODO: temporary hack from https://github.com/nix-community/home-manager/issues/1341#issuecomment-778820334
    # Even though nix-darwin support symlink to ~/Application or ~/Application/Nix Apps
    # Spotlight doesn't like symlink as all or it won't index them
    home.activation = {
      copyApplications =
        let
          apps = pkgs.buildEnv {
            name = "home-manager-applications";
            paths = config.home.packages;
            pathsToLink = "/Applications";
          };
        in
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          baseDir="$HOME/Applications/Home Manager Apps"
          if [ -d "$baseDir" ]; then
            rm -rf "$baseDir"
          fi
          mkdir -p "$baseDir"
          for appFile in ${apps}/Applications/*; do
            target="$baseDir/$(basename "$appFile")"
            $DRY_RUN_CMD cp ''${VERBOSE_ARG:+-v} -fHRL "$appFile" "$baseDir"
            $DRY_RUN_CMD chmod ''${VERBOSE_ARG:+-v} -R +w "$target"
          done
        '';
    };
    home.username = "matthias";
    home.homeDirectory = lib.mkForce "/Users/matthias/"; #c
    home.packages = with pkgs; [
      alacritty
      bottom
      bun
      buf
      direnv
      esphome
      git
      jless
      jq
      lazygit
      modd
      nodePackages_latest.pnpm
      putty
      rustup
      skhd
      tmux
      utm
      yabai
      zsh
    ];

    home.stateVersion = "23.05";
  };

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    casks = [
      "obs"
      "steam"
    ];
  };
}
