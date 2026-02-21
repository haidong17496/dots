{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.prompt.starship;
in {
  options.nkm.prompt.starship = {
    enable = lib.mkEnableOption "Starship Cross-Shell Prompt";
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;

      # Automatically integrate with active shells (Zsh, Bash, etc.)
      enableZshIntegration = true;

      # --- UI Configuration ---
      settings = {
        add_newline = false;

        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
  };
}
