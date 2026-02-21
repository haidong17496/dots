{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.services.nightLight;

  # Script to toggle wlsunset
  toggleScript = pkgs.writeShellScriptBin "toggle-nightlight" ''
    if systemctl --user is-active --quiet wlsunset; then
        systemctl --user stop wlsunset
        ${pkgs.libnotify}/bin/notify-send "Night Light" "Off (6500K)" -t 2000
    else
        systemctl --user start wlsunset
        ${pkgs.libnotify}/bin/notify-send "Night Light" "On (${toString cfg.temperature}K)" -t 2000
    fi
  '';
in {
  options.nkm.services.nightLight = {
    enable = lib.mkEnableOption "Night Light (wlsunset)";

    temperature = lib.mkOption {
      type = lib.types.int;
      default = 4000;
      description = "Color temperature (Kelvin) for night mode";
    };

    latitude = lib.mkOption {
      type = lib.types.str;
      default = "21.0"; # Example: Hanoi
    };

    longitude = lib.mkOption {
      type = lib.types.str;
      default = "105.8"; # Example: Hanoi
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [toggleScript pkgs.wlsunset];

    # Systemd service for wlsunset
    # We don't verify location automatically to keep it manual/simple with the toggle,
    # but wlsunset can do auto-mode if you pass lat/long.
    # Here we set up manual mode via service for the toggle script.
    systemd.user.services.wlsunset = {
      Unit = {
        Description = "Night Light (wlsunset)";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };

      Service = {
        # Using manual mode (-T) based on config
        ExecStart = "${pkgs.wlsunset}/bin/wlsunset -T ${toString cfg.temperature}";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
