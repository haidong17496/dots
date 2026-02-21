{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.shell.zsh;
in {
  options.nkm.shell.zsh = {
    enable = lib.mkEnableOption "Zsh Shell Environment";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      # --- Core Features ---
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      # --- History Management ---
      history = {
        size = 5000;
        saveNoDups = true;
        append = true;
        share = true;
        ignoreSpace = true;
        ignoreDups = true;
        ignoreAllDups = true;
      };

      # --- Keybindings & Search ---
      historySubstringSearch = {
        searchUpKey = "^p";
        searchDownKey = "^n";
      };

      # Case-insensitive completion
      completionInit = ''
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      '';

      # Accept autosuggestion with Ctrl+E
      initContent = ''
        bindkey '^e' autosuggest-accept
      '';

      # --- Aliases ---
      shellAliases = {
        # Nix Helper (nh) aliases - pointing to our new 'dots' directory
        nrs = "nh os switch ~/dots";
        nrb = "nh os boot ~/dots";
        ngc = "sudo nh clean all --keep 3";
        nlg = "nixos-rebuild list-generations";
      };
    };
  };
}
