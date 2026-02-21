{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.nkm.editor.nvim;
in {
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./options.nix
    ./plugins/ide.nix
    ./plugins/ui.nix
    ./plugins/tools.nix
  ];

  options.nkm.editor.nvim = {
    enable = lib.mkEnableOption "Neovim (Nixvim Configuration)";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      # Performance optimizations
      performance.byteCompileLua.enable = true;

      # Clipboard integration (Wayland support)
      clipboard.register = "unnamedplus";
      clipboard.providers.wl-copy.enable = true;
    };
  };
}
