{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.services.hypridle;
in {
  options.nkm.services.hypridle = {
    enable = lib.mkEnableOption "Hypridle (Idle Management Daemon)";

    # Allow dynamically changing the locker without modifying this module!
    lockCmd = lib.mkOption {
      type = lib.types.str;
      default = "pidof hyprlock || hyprlock";
      description = "The command used to lock the screen (e.g., hyprlock, swaylock)";
    };
  };

  config = lib.mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = cfg.lockCmd;
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "niri msg action power-on-monitors";
        };

        listener = [
          # 2.5 min: Dim screen
          {
            timeout = 150;
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }
          # 5 min: Lock screen
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          # 5.5 min: Screen off
          {
            timeout = 330;
            on-timeout = "niri msg action power-off-monitors";
            on-resume = "niri msg action power-on-monitors";
          }
          # 30 min: Suspend
          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
