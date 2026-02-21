{
  config,
  lib,
  pkgs,
  user,
  inputs,
  ...
}: let
  cfg = config.nkm.system.i18n;
in {
  imports = [
    inputs.fcitx5-lotus.nixosModules.fcitx5-lotus
  ];

  options.nkm.system.i18n = {
    enable = lib.mkEnableOption "Vietnamese Input Method (fcitx5-lotus)";
  };

  config = lib.mkIf cfg.enable {
    services.fcitx5-lotus = {
      enable = true;
      user = user;
    };

    environment.sessionVariables = {
      GLFW_IM_MODULE = "ibus";
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
    };
  };
}
