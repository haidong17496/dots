{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.system.bluetooth;
in {
  options.nkm.system.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth & OBEX File Transfer";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };

    environment.systemPackages = with pkgs; [bluez];

    # User Service for Bluetooth OBEX (File Transfer)
    systemd.user.services.obex = {
      description = "Bluetooth OBEX service for file transfer";
      wantedBy = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];

      serviceConfig = {
        ExecStart = "${pkgs.bluez}/libexec/bluetooth/obexd --nodetach --root=%h/Downloads";
        Restart = "on-failure";
        Type = "dbus";
        BusName = "org.bluez.obex";
      };
    };
  };
}
