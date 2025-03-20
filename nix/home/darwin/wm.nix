{ pkgs, ... }:
{
  services.yabai.enable = true;
  services.yabai.package = pkgs.yabai;
  services.yabai.enableScriptingAddition = false;
  services.yabai.extraConfig = ''
    yabai -m config layout bsp

    yabai -m config window_placement second_child

    yabai -m config window_gap 12
    yabai -m config top_padding 4
    yabai -m config bottom_padding 4
    yabai -m config right_padding 4
    yabai -m config left_padding 4

    yabai -m config mouse_follows_focus on
    yabai -m config mouse_modifier alt
    # left click and drag
    yabai -m config mouse_action1 move
    # right click and drag
    yabai -m config mouse_action2 resize
    yabai -m config mouse_drop_action swap

    #disable yabai for these apps
    yabai -m rule --add app="^Discord$" manage=off
    yabai -m rule --add app="^1Password$" manage=off
  '';

  services.skhd.enable = true;
  services.skhd.package = pkgs.skhd;
  services.skhd.skhdConfig = ''
    ctrl + alt - q: yabai --stop-service
    ctrl + alt -s: yabai --start-service

    # changing window focus
    alt - s: yabai -m window --focus south
    alt - w: yabai -m window --focus north
    alt - a: yabai -m window --focus west
    alt - d: yabai -m window --focus east

    # rotate layout clockwise
    shift + alt - c: yabai -m space --rotate 90

    # rotate layout anti-clockwise
    shift + alt - a: yabai -m space --rotate 270

    # flip alonne x-axis
    shift + alt - x: yabai -m space --mirror x-axis

    # flip alonne y-axis
    shift + alt - y: yabai -m space --mirror y-axis

    # toggle window float
    shift + alt - t: yabai -m window --toggle float --grid 4:4:1:1:2:2

    # maximize a window
    shift + alt - m: yabai -m window --toggle zoom-fullscreen

    # reset window size
    shift + alt - e: yabai -m space --balance

    # swap windows
    shift + alt - h: yabai -m window --warp west
    shift + alt - j: yabai -m window --warp south
    shift + alt - k: yabai -m window --warp north
    shift + alt - l: yabai -m window --warp east

    # move window and split
    ctrl + alt - h: yabai -m window --warp west
    ctrl + alt - j: yabai -m window --warp south
    ctrl + alt - k: yabai -m window --warp north
    ctrl + alt - l: yabai -m window --warp east
  '';
}
