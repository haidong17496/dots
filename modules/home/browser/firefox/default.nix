{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.nkm.browser.firefox;
in {
  imports = [
    ./settings.nix
    ./search.nix
  ];

  options.nkm.browser.firefox = {
    enable = lib.mkEnableOption "Firefox Browser (Hardened & Rice)";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;

        # --- EXTENSIONS ---
        # Using the flake input 'firefox-addons' to get latest versions
        extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          ublock-origin
          vimium
          translate-web-pages
          darkreader
        ];

        userChrome = builtins.readFile ./userChrome.css;
        userContent = builtins.readFile ./userContent.css;
      };
    };
  };
}
