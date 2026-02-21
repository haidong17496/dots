{...}: {
  programs.nixvim = {
    # --- Colorscheme ---
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = true;
      };
    };

    plugins = {
      # --- File Explorer ---
      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window = true;
          window = {
            width = 30;
            auto_expand_width = false;
          };
          filesystem = {
            follow_current_file.enabled = true;
            use_libuv_file_watcher = true;
          };
        };
      };

      # --- Status Line ---
      lualine = {
        enable = true;
        settings.options.theme = "catppuccin";
      };

      # --- Icons ---
      web-devicons.enable = true;

      # --- Markdown Preview ---
      markview = {
        enable = true;
        settings.preview.modes = ["n" "no" "c"];
      };
    };

    # Keymap for File Explorer
    keymaps = [
      {
        mode = "n";
        key = "\\";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Toggle Explorer";
      }
    ];
  };
}
