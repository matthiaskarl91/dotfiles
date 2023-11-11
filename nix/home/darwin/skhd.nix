{ pkgs, ... }:
{
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
}
