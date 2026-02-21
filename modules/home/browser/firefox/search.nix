{pkgs, ...}: {
  programs.firefox.profiles.default.search = {
    force = true;
    default = "google";
    engines = {
      "archwiki" = {
        urls = [{template = "https://wiki.archlinux.org/index.php?search={searchTerms}";}];
        icon = "https://wiki.archlinux.org/favicon.ico";
        updateInterval = 24 * 60 * 60 * 1000;
        definedAliases = ["!aw"];
      };

      "nix-packages" = {
        urls = [
          {
            template = "https://search.nixos.org/packages";
            params = [
              {
                name = "type";
                value = "packages";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = ["!nix"];
      };

      "NixOS Options" = {
        urls = [
          {
            template = "https://search.nixos.org/options";
            params = [
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }
        ];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = ["!opt"];
      };

      "youTube" = {
        urls = [{template = "https://www.youtube.com/results?search_query={searchTerms}";}];
        definedAliases = ["!yt"];
      };
    };
  };
}
