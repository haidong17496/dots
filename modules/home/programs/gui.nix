{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.programs.guiApps;
in {
  options.nkm.programs.guiApps = {
    # --- Editors ---
    editors = {
      zed = {
        enable = lib.mkEnableOption "Zed Editor (GPU Accelerated)";
      };

      vscode = {
        enable = lib.mkEnableOption "Visual Studio Code";
      };
    };

    # --- Productivity ---
    productivity = {
      obsidian = {
        enable = lib.mkEnableOption "Obsidian Note Taking";
      };

      logseq = {
        enable = lib.mkEnableOption "Logseq Note Taking (Privacy first)";
      };
    };

    # --- Utilities ---
    utils = {
      easyeffects = {
        enable = lib.mkEnableOption "EasyEffects (Audio Equalizer & Processing)";
      };
    };
  };

  # Use mkMerge to combine configurations based on which flags are enabled
  config = lib.mkMerge [
    # Zed
    (lib.mkIf cfg.editors.zed.enable {
      home.packages = [pkgs.zed-editor];
    })

    # VS Code
    (lib.mkIf cfg.editors.vscode.enable {
      home.packages = [pkgs.vscode];
    })

    # Obsidian
    (lib.mkIf cfg.productivity.obsidian.enable {
      home.packages = [pkgs.obsidian];
    })

    # Logseq
    (lib.mkIf cfg.productivity.logseq.enable {
      home.packages = [pkgs.logseq];
    })

    # EasyEffects
    (lib.mkIf cfg.utils.easyeffects.enable {
      services.easyeffects.enable = true;
    })
  ];
}
