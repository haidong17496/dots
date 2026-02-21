{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.services.swaync;
in {
  options.nkm.services.swaync = {
    enable = lib.mkEnableOption "SwayNC Notification Daemon";
  };

  config = lib.mkIf cfg.enable {
    services.swaync = {
      enable = true;
      # Automatically read config and style from the same directory
      settings = builtins.fromJSON (builtins.readFile ./config.json);
      style = builtins.readFile ./style.css;
    };
  };
}
