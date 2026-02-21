{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.programs.media;
in {
  options.nkm.programs.media = {
    # --- Image & Document Viewers ---
    viewers = {
      zathura = {
        enable = lib.mkEnableOption "Zathura PDF/DjVu Viewer";
      };

      imv = {
        enable = lib.mkEnableOption "IMV Image Viewer";
      };
    };

    # --- Media Players ---
    players = {
      mpv = {
        enable = lib.mkEnableOption "MPV Video Player (Supercharged)";
      };
    };
  };

  # Use mkMerge to combine configurations based on enabled flags
  config = lib.mkMerge [
    # --- Zathura Configuration ---
    (lib.mkIf cfg.viewers.zathura.enable {
      programs.zathura = {
        enable = true;

        # Add format support (PDF + DjVu)
        package = pkgs.zathura.override {
          plugins = [
            pkgs.zathuraPkgs.zathura_pdf_mupdf
            pkgs.zathuraPkgs.zathura_djvu
          ];
        };

        # Catppuccin Mocha Theme
        options = {
          default-bg = "#1e1e2e";
          default-fg = "#cdd6f4";
          statusbar-bg = "#313244";
          statusbar-fg = "#cdd6f4";
          inputbar-bg = "#313244";
          inputbar-fg = "#cdd6f4";
          notification-bg = "#313244";
          notification-fg = "#cdd6f4";
          notification-error-bg = "#f38ba8";
          notification-error-fg = "#cdd6f4";
          notification-warning-bg = "#fab387";
          notification-warning-fg = "#1e1e2e";
          highlight-color = "rgba(245, 194, 231, 0.5)";
          highlight-active-color = "rgba(245, 194, 231, 0.5)";
          completion-bg = "#313244";
          completion-fg = "#cdd6f4";
          completion-highlight-bg = "#585b70";
          completion-highlight-fg = "#cdd6f4";
          recolor-lightcolor = "#1e1e2e";
          recolor-darkcolor = "#cdd6f4";
          recolor = "true";
          selection-clipboard = "clipboard";
        };
      };
    })

    # --- IMV Configuration ---
    (lib.mkIf cfg.viewers.imv.enable {
      programs.imv.enable = true;
    })

    # --- MPV Configuration ---
    (lib.mkIf cfg.players.mpv.enable {
      programs.mpv = {
        enable = true;
        scripts = with pkgs.mpvScripts; [
          uosc # Modern UI
          mpris # Media controls integration
          thumbfast # Thumbnails on hover
        ];

        config = {
          osc = "no";
          osd-bar = "no";
          border = "no";
          cursor-autohide = 1000;

          # Video & Hardware Decoding
          vo = "gpu";
          gpu-api = "opengl";
          hwdec = "vaapi";

          # Quality & Interpolation
          video-sync = "display-resample";
          interpolation = "yes";
          tscale = "oversample";

          # Scaling
          dither-depth = "auto";
          scale = "bilinear";
          cscale = "bilinear";
        };
      };
    })
  ];
}
