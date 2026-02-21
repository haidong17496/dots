{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.system.hardware.nvidia;
in {
  options.nkm.system.hardware.nvidia = {
    enable = lib.mkEnableOption "NVIDIA Drivers & Configuration";

    # Toggle for older cards (like GT 920M)
    legacy470 = lib.mkEnableOption "Use Legacy 470 Drivers";

    # Prime Offload Bus IDs (Must be set per host)
    intelBusId = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Bus ID of the Intel GPU (e.g., PCI:0:2:0)";
    };

    nvidiaBusId = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Bus ID of the Nvidia GPU (e.g., PCI:1:0:0)";
    };
  };

  config = lib.mkIf cfg.enable {
    # Accept NVIDIA License only when this module is enabled
    nixpkgs.config.nvidia.acceptLicense = true;

    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        libvdpau-va-gl
      ];
    };

    # Load Nvidia Drivers
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;

      # Use the open source kernel module (not supported on legacy)
      open = false;

      nvidiaSettings = true;

      # Select Package Version
      package =
        if cfg.legacy470
        then config.boot.kernelPackages.nvidiaPackages.legacy_470
        else config.boot.kernelPackages.nvidiaPackages.stable;

      # Prime Offload Configuration
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = cfg.intelBusId;
        nvidiaBusId = cfg.nvidiaBusId;
      };
    };

    # Enable gpu-screen-recorder at system level for permissions (CAP_SYS_ADMIN)
    programs.gpu-screen-recorder.enable = true;
  };
}
