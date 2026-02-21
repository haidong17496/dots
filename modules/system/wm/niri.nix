{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.system.wm.niri;
in {
  options.nkm.system.wm.niri = {
    enable = lib.mkEnableOption "Niri Wayland Compositor (System Level)";
  };

  config = lib.mkIf cfg.enable {
    # --- Window Manager ---
    programs.niri.enable = true;

    # DBus is essential for Wayland services to communicate
    services.dbus.enable = true;

    # --- XDG Desktop Portal (For Screen Sharing & File Dialogs) ---
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = ["gnome" "gtk"];
        };
      };
    };

    # --- Environment Variables ---
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      XDG_CURRENT_DESKTOP = "niri";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}
