{
  config,
  pkgs,
  hostname,
  user,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # --- Hostname & Networking ---
  networking.hostName = hostname;

  # =======================================================
  # SYSTEM MODULES CONFIGURATION
  # =======================================================
  # Base System
  nkm.system.core.enable = true;
  nkm.system.network.enableNetworkManager = true;

  # Hardware & Peripherals
  nkm.system.audio.enable = true;
  nkm.system.bluetooth.enable = true;
  nkm.system.fonts.enable = true;
  nkm.system.hardware.nvidia = {
    enable = true;
    legacy470 = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Input Method
  nkm.system.i18n.enable = true;

  # Window Manager
  nkm.system.wm.niri.enable = true;

  # Display Manager
  nkm.system.displayManager.tuigreet.enable = true;

  # =======================================================

  # --- System User ---
  users.users.${user} = {
    isNormalUser = true;
    description = "Primary User";
    extraGroups = ["networkmanager" "wheel" "video" "input" "audio"];
    shell = pkgs.zsh;
  };

  # Enable zsh globally
  programs.zsh.enable = true;

  # --- External Storage Rules ---
  systemd.tmpfiles.rules = [
    "d /mnt/backup 0755 ${user} users -"
  ];

  # --- State Version ---
  system.stateVersion = "25.11";
}
