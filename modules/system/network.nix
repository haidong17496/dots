{
  config,
  lib,
  ...
}: let
  cfg = config.nkm.system.network;
in {
  options.nkm.system.network = {
    enableNetworkManager = lib.mkEnableOption "NetworkManager for dynamic network configuration";

    # Custom option to easily open TCP ports per-host
    openTCPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      default = [];
      description = "List of TCP ports to open in the firewall";
    };

    # Custom option to edit the /etc/hosts file easily
    extraHosts = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra entries to append to /etc/hosts";
    };
  };

  config = lib.mkIf cfg.enableNetworkManager {
    networking.networkmanager.enable = true;

    # Apply firewall settings based on our custom options
    networking.firewall = {
      enable = true;
      allowedTCPPorts = cfg.openTCPPorts;
    };

    # Apply the hosts file modifications
    networking.extraHosts = cfg.extraHosts;
  };
}
