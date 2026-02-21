{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.services.hyprpaper;
  wallpaper = "${../../../images/wallpaper.png}";
in {
  options.nkm.services.hyprpaper = {
    enable = lib.mkEnableOption "Hyprpaper Wallpaper Daemon";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.hyprpaper];
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;

        preload = [(builtins.toString wallpaper)];

        wallpaper = [
          "eDP-1,${builtins.toString wallpaper}"
          "DP-1,${builtins.toString wallpaper}"
        ];
      };
    };
  };
}
