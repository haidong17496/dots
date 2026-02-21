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
