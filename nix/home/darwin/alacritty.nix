{ config, pkgs, lib, ... }:
{
  home-manager.users.matthiaskarl.programs.alacritty = {
    enable = true;
    settings = {
      font = rec {
        size = 14;
        normal = {
          family = "Dank Mono";
          style = "Regular";
        };
        bold = {
          style = "Bold";
        };
        italic = {
          style = "Italic";
        };
        bold_italic = {
          style = "Bold Italic";
        };
      };
      window = {
        option_as_alt = "Both";
        padding = {
          x = 12;
          y = 12;
        };
        dynamic_padding = false;
        decoration = "Buttonless";
        startup_mode = "Windowed";
        opacity = 1;
      };
    };
  };
}
