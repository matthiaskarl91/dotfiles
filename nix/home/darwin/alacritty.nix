{ config, pkgs, lib, ... }:
{
  home-manager.users.matthiaskarl.programs.alacritty = {
    enable = true;
    settings = {
      shell.program = "${pkgs.zsh}/bin/zsh";
      cursor.style = "Beam";

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
      colors = {
        primary = {
          background = "#161617";
          foreground = "#c9c7cd";
        };
        cursor = {
          text = "#c9c7cd";
          cursor = "#757581";
        };
        normal = {
          black = "#27272a";
          red = "#f5a191";
          green = "#90b99f";
          yellow = "#e6b99d";
          blue = "#aca1cf";
          magenta = "#e29eca";
          cyan = "#ea83a5";
          white = "#c1c0d4";
        };
        bright = {
          black = "#353539";
          red = "#ffae9f";
          green = "#9dc6ac";
          yellow = "#f0c5a9";
          blue = "#b9aeda";
          magenta = "#ecaad6";
          cyan = "#f59ab2";
          white = "#cac9dd";
        };
      };
    };
  };
}
