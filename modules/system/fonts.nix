{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.system.fonts;
in {
  options.nkm.system.fonts = {
    enable = lib.mkEnableOption "Essential System Fonts (Noto, JetBrainsMono)";
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        nerd-fonts.jetbrains-mono
      ];

      fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = ["JetBrainsMono Nerd Font"];
          serif = ["Noto Serif" "Noto Color Emoji"];
          sansSerif = ["Noto Sans" "Noto Color Emoji"];
        };
      };
    };
  };
}
