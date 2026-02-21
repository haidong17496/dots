{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      # --- 1. LSP (Language Server Protocol) ---
      lsp = {
        enable = true;

        # Language Servers
        servers = {
          nixd.enable = true; # Nix
          basedpyright.enable = true; # Python
        };

        # Keymaps (LSP actions)
        keymaps = {
          silent = true;
          diagnostic = {
            "<leader>j" = "goto_next";
            "<leader>k" = "goto_prev";
          };
          lspBuf = {
            gd = "definition";
            gD = "declaration";
            K = "hover";
            "<F2>" = "rename";
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
          };
        };
      };

      # --- 2. COMPLETION ---
      blink-cmp = {
        enable = true;
        settings = {
          keymap = {
            preset = "default";
            "<C-space>" = ["show" "show_documentation" "hide_documentation"];
            "<C-e>" = ["hide"];
            "<C-y>" = ["select_and_accept"];

            # Navigate
            "<C-n>" = ["select_next" "fallback"];
            "<C-p>" = ["select_prev" "fallback"];
          };

          appearance = {
            use_nvim_cmp_as_default = true;
            nerd_font_variant = "mono";
          };

          sources.default = ["lsp" "path" "snippets" "buffer"];
          signature.enabled = true;
        };
      };

      # Dependency for snippets
      friendly-snippets.enable = true;

      # --- 3. FORMATTING ---
      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            lsp_fallback = true;
            timeout_ms = 500;
          };

          formatters_by_ft = {
            python = ["black"];
            nix = ["alejandra"];
            "*" = ["trim_whitespace"];
          };
        };
      };
    };

    # Keymap for manual formatting
    keymaps = [
      {
        mode = "n";
        key = "<leader>cf";
        action = "<cmd>lua require('conform').format({ lsp_fallback = true })<CR>";
        options = {
          silent = true;
          desc = "Format Buffer";
        };
      }
    ];

    # Install formatters
    extraPackages = with pkgs; [
      alejandra
      black
    ];
  };
}
