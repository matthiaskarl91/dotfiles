{ pkgs, ... }:
{
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    package = pkgs.yabai;
    config = {
      layout = "bsp";
      window_placement = "second_child";
      window_gap = 16;
      top_padding = 12;
      bottom_padding = 12;
      right_padding = 12;
      left_padding = 12;
      mouse_follows_focus = "on";
      mouse_modifier = "alt";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "swap";
    };
    extraConfig = ''
      yabai -m rule --add app="^Discord$" manage=off
      yabai -m rule --add app="^1Password$" manage=off
    '';
  };
}
