{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.programs.tuiApps;
in {
  options.nkm.programs.tuiApps = {
    # --- File Manager ---
    fileManager = {
      yazi = {
        enable = lib.mkEnableOption "Yazi (Blazing fast terminal file manager)";
      };
    };

    # --- System & Audio ---
    audio = {
      pulsemixer = {
        enable = lib.mkEnableOption "Pulsemixer (CLI audio mixer)";
      };
    };

    # --- Network & Bluetooth ---
    bluetooth = {
      bluetuith = {
        enable = lib.mkEnableOption "Bluetuith (TUI bluetooth manager)";
      };
    };

    # --- System Monitors ---
    system = {
      bottom = {
        enable = lib.mkEnableOption "Bottom (Graphical system monitor for terminal)";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.fileManager.yazi.enable {
      programs.yazi = {
        enable = true;
        enableZshIntegration = true;
      };
    })

    # Pulsemixer
    (lib.mkIf cfg.audio.pulsemixer.enable {
      home.packages = [pkgs.pulsemixer];
    })

    # Bluetuith
    (lib.mkIf cfg.bluetooth.bluetuith.enable {
      home.packages = [pkgs.bluetuith];
    })

    # Bottom
    (lib.mkIf cfg.system.bottom.enable {
      programs.bottom = {
        enable = true;
        settings = {flags = {color = "catppuccin";};};
      };
    })
  ];
}
