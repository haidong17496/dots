{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.theme;
in {
  options.nkm.theme = {
    enable = lib.mkEnableOption "Manual System Theme (GTK, Icons, Cursor)";
  };

  config = lib.mkIf cfg.enable {
    # 1. Packages
    home.packages = with pkgs; [
      papirus-icon-theme
      bibata-cursors
      adwaita-icon-theme
      gnome-themes-extra
    ];

    # 2. GTK Theme
    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    };

    # 3. Cursor (Trỏ chuột)
    home.pointerCursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    # 4. Dconf (GNOME settings)
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };
}
