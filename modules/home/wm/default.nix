{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.wm.niri;
in {
  options.nkm.wm.niri = {
    enable = lib.mkEnableOption "Niri Window Manager Configuration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wl-clipboard
      libnotify
      grim
      slurp
      swaybg
    ];

    # Map the configuration files to ~/.config/niri/
    xdg.configFile = {
      "niri/config.kdl".source = ./config.kdl;
      "niri/conf".source = ./conf;
    };
  };
}
