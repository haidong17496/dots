{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      # --- Telescope (Fuzzy Finder) ---
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
          ui-select.enable = true;
        };
        settings.defaults = {
          layout_config.prompt_position = "top";
          sorting_strategy = "ascending";
          file_ignore_patterns = ["^.git/" "^node_modules/" "^target/"];
        };
      };

      # --- Treesitter (Syntax Highlight) ---
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };

        grammarPackages = with pkgs.vimPlugins.nvim-treesitter-parsers; [
          nix
          python
          rust
          lua
          bash
          markdown
          markdown_inline
          toml
          json
          yaml
          vim
          vimdoc
          regex
        ];
      };

      # --- Which Key (Keybinding Helper) ---
      which-key = {
        enable = true;
        settings.spec = [
          {
            __unkeyed-1 = "<leader>f";
            group = "File/Find";
            icon = " ";
          }
          {
            __unkeyed-1 = "<leader>c";
            group = "Code";
            icon = " ";
          }
          {
            __unkeyed-1 = "<leader>d";
            group = "Debug/Diagnostics";
            icon = " ";
          }
          {
            __unkeyed-1 = "g";
            group = "Goto";
          }
        ];
      };

      # --- Flash (Motion) ---
      flash = {
        enable = true;
        settings = {
          labels = "asdfghjklqwertyuiopzxcvbnm";
          search.mode = "exact";
          jump.autojump = false;
        };
      };

      # --- Autopairs ---
      nvim-autopairs = {
        enable = true;
        settings.check_ts = true;
      };

      # --- Tmux Navigator (Seamless navigation) ---
      tmux-navigator.enable = true;
    };

    # --- Telescope Keymaps ---
    keymaps = [
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<CR>";
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<CR>";
        options.desc = "Live grep";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<CR>";
        options.desc = "Find buffers";
      }

      # LSP Telescope
      {
        mode = "n";
        key = "gr";
        action = "<cmd>Telescope lsp_references<CR>";
        options.desc = "[LSP] References";
      }
      {
        mode = "n";
        key = "<leader>ds";
        action = "<cmd>Telescope lsp_document_symbols<CR>";
        options.desc = "[LSP] Symbols";
      }
      {
        mode = "n";
        key = "<leader>fd";
        action = "<cmd>Telescope diagnostics<CR>";
        options.desc = "Find Diagnostics";
      }

      # Flash Keymaps
      {
        mode = ["n" "x" "o"];
        key = "s";
        action = "<cmd>lua require('flash').jump()<CR>";
        options.desc = "Flash Jump";
      }
    ];
  };
}
