{
  config,
  lib,
  pkgs,
  ...
}: let
  # Create a shorthand for our specific option path to keep the code clean
  cfg = config.nkm.terminal.alacritty;
in {
  # ==============================================================
  # 1. OPTIONS: Defining the toggle switch
  # ==============================================================
  options.nkm.terminal.alacritty = {
    enable = lib.mkEnableOption "Alacritty Terminal Emulator";
  };

  # ==============================================================
  # 2. CONFIGURATION: What happens when the switch is ON
  # ==============================================================
  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;

      settings = {
        # --- Window Settings ---
        window = {
          padding = {
            x = 8;
            y = 8;
          };
          dynamic_padding = true;
          decorations = "None";
        };

        # --- Color Scheme (Catppuccin Mocha) ---
        colors = {
          primary = {
            background = "#1e1e2e";
            foreground = "#cdd6f4";
          };
        };

        # --- Typography ---
        font = {
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
          size = 12.0;
        };
      };
    };
  };
}
