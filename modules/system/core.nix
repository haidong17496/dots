{
  config,
  lib,
  pkgs,
  user,
  ...
}: let
  cfg = config.nkm.system.core;
in {
  options.nkm.system.core = {
    enable = lib.mkEnableOption "Core System Configuration";
  };

  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    time.timeZone = "Asia/Ho_Chi_Minh";
    i18n.defaultLocale = "en_US.UTF-8";

    nix.settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };

    nixpkgs.config.allowUnfree = true;

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 3";
    };

    environment.variables.FLAKE = "/home/${user}/dots";

    environment.systemPackages = with pkgs; [
      git
      wget
      curl
      p7zip
      killall
    ];
  };
}
