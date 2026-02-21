{
  config,
  lib,
  ...
}: let
  cfg = config.nkm.system.audio;
in {
  options.nkm.system.audio = {
    enable = lib.mkEnableOption "Pipewire Audio System";
  };

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };
}
