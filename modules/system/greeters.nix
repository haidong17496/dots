{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.system.displayManager;
in {
  options.nkm.system.displayManager = {
    # Option for Ly
    ly.enable = lib.mkEnableOption "Ly Display Manager (Lightweight TUI)";

    # Option for Tuigreet
    tuigreet = {
      enable = lib.mkEnableOption "Tuigreet Display Manager";
      defaultSession = lib.mkOption {
        type = lib.types.str;
        default = "niri-session";
        description = "The default session command to run after login";
      };
    };

    # easily add sddm.enable = lib.mkEnableOption "SDDM"; here in the future
  };

  # Using mkMerge allows us to apply configurations conditionally based on which toggle is ON
  config = lib.mkMerge [
    # --- Ly Configuration ---
    (lib.mkIf cfg.ly.enable {
      services.displayManager.ly.enable = true;
    })

    # --- Tuigreet Configuration ---
    (lib.mkIf cfg.tuigreet.enable {
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            # Added --remember-session so it remembers your choice between Niri/Hyprland
            command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --asterisks --window-padding 1 --greeting 'Hi, mate. Welcome home! ^^' --cmd ${cfg.tuigreet.defaultSession}";
            user = "greeter";
          };
        };
      };
    })
  ];
}
