{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.nkm.launcher.walker;
in {
  imports = [
    inputs.walker.homeManagerModules.default
  ];

  options.nkm.launcher.walker = {
    enable = lib.mkEnableOption "Walker Application Launcher";
  };

  config = lib.mkIf cfg.enable {
    programs.walker = {
      enable = true;
      runAsService = true;

      # --- General Configuration ---
      config = {
        ui = {
          fullscreen = false;
        };

        force_keyboard_focus = false;
        close_when_open = true;
        click_to_close = true;
        single_click_activation = true;

        theme = "nkmTheme";

        # --- Search Providers ---
        exact_search_prefix = "'";
        global_argument_delimiter = "#";

        providers = {
          default = ["desktopapplications" "calc" "runner" "websearch"];
          empty = ["desktopapplications"];
          max_results = 50;

          prefixes = [
            {
              prefix = ";";
              provider = "providerlist";
            }
            {
              prefix = ">";
              provider = "runner";
            }
            {
              prefix = "/";
              provider = "files";
            }
            {
              prefix = "=";
              provider = "calc";
            }
            {
              prefix = "@";
              provider = "websearch";
            }
            {
              prefix = ":";
              provider = "clipboard";
            }
            {
              prefix = "!";
              provider = "todo";
            }
          ];

          runner = {argument_delimiter = " ";};
          clipboard = {time_format = "%d.%m. - %H:%M";};
        };

        # --- Keybindings ---
        keybinds = {
          close = ["Escape"];
          next = ["Down" "ctrl j"];
          previous = ["Up" "ctrl k"];
          quick_activate = ["F1" "F2" "F3"];
          toggle_exact = ["ctrl e"];
        };
      };

      # --- Styling ---
      themes = {
        nkmTheme = {
          style = builtins.readFile ./style.css;
        };
      };
    };
  };
}
