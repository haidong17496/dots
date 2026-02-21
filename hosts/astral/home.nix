{
  config,
  pkgs,
  user,
  ...
}: {
  imports = [
    ../../modules/home
  ];

  # --- User Information ---
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  # =======================================================
  # MODULES CONFIGURATION
  # =======================================================

  # --- Terminal & Shell ---
  nkm.terminal.alacritty.enable = true;
  nkm.shell.zsh.enable = true;
  nkm.prompt.starship.enable = true;

  # Window Manager
  nkm.wm.niri.enable = true;

  # App Launcher
  nkm.launcher.walker.enable = true;

  # UI Daemons
  nkm.statusbar.waybar.enable = true;
  nkm.services.swaync.enable = true;

  # Idle & Lock Screen
  nkm.services.hypridle = {
    enable = true;
    lockCmd = "pidof hyprlock || hyprlock";
  };
  nkm.programs.hyprlock.enable = true;

  # Browser
  nkm.browser.firefox.enable = true;

  # Editor
  nkm.editor.nvim.enable = true;

  # Application
  nkm.programs.media = {
    viewers.zathura.enable = true;
    viewers.imv.enable = true;
    players.mpv.enable = true;
  };

  nkm.programs.guiApps = {
    editors.zed.enable = true;
    productivity.obsidian.enable = true;
    utils.easyeffects.enable = true;
  };

  # Base Utilities
  nkm.programs.commonUtils.enable = true;

  # Tools
  nkm.tools.nirishot.enable = true;
  nkm.tools.screenRecord.enable = true;

  # =======================================================

  # --- State Version ---
  home.stateVersion = "25.11";
}
