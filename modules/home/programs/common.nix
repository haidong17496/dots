{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.programs.commonUtils;
in {
  options.nkm.programs.commonUtils = {
    enable = lib.mkEnableOption "Common GUI and CLI Utilities (jq, wl-clipboard, etc.)";
  };

  config = lib.mkIf cfg.enable {
    # Core utilities used by many scripts and apps
    home.packages = with pkgs; [
      wl-clipboard # Clipboard management for Wayland
      libnotify # Library for sending desktop notifications (notify-send)
      jq # Command-line JSON processor
      fd # Simple, fast and user-friendly alternative to 'find'
      ripgrep # Fast search tool
      bottom # System monitor (btm)
      pulsemixer # CLI audio mixer
    ];
  };
}
