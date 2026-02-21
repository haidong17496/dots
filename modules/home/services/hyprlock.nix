{
  config,
  lib,
  pkgs,
  user,
  ...
}: let
  cfg = config.nkm.programs.hyprlock;

  # --- Variables for the Rust-themed lock screen ---
  font_family = "JetBrainsMono Nerd Font Mono";
  font_size = 17;
  time_size = 90;
  code_base_x = -220;
  indent_1 = code_base_x + 40;
  toString = x: builtins.toString x;
in {
  options.nkm.programs.hyprlock = {
    enable = lib.mkEnableOption "Hyprlock (Screen Locker)";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
          no_fade_in = false;
          grace = 0;
          disable_loading_bar = true;
        };

        background = [
          {
            path = "/home/${user}/dots/images/wallpaper.png";
            blur_passes = 3;
            blur_size = 4;
            brightness = 0.5;
          }
        ];

        input-field = [
          {
            size = "250, 40";
            position = "${toString (indent_1 + 10)}, -35";
            monitor = "";
            dots_center = false;
            inner_color = "rgba(0, 0, 0, 0)";
            outer_color = "rgba(0, 0, 0, 0)";
            font_color = "rgb(166, 227, 161)";
            check_color = "rgb(137, 180, 250)";
            fail_color = "rgb(243, 139, 168)";
            halign = "center";
            valign = "center";
            zindex = 10;
          }
        ];

        # Add your awesome Rust labels here
        label = [
          {
            text = "cmd[update:1000] echo \"$(date +'%H:%M')\"";
            color = "rgb(205, 214, 244)";
            font_size = time_size;
            font_family = "${font_family} ExtraBold";
            position = "0, 200";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}
