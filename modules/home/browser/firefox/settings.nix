{...}: {
  programs.firefox.profiles.default.settings = {
    # --- PRIVACY & TELEMETRY (Hardening) ---
    "datareporting.healthreport.uploadEnabled" = false;
    "datareporting.policy.dataSubmissionEnabled" = false;
    "toolkit.telemetry.unified" = false;
    "toolkit.telemetry.enabled" = false;
    "toolkit.telemetry.server" = "data:,";
    "toolkit.telemetry.archive.enabled" = false;
    "toolkit.telemetry.newProfilePing.enabled" = false;
    "toolkit.telemetry.shutdownPingSender.enabled" = false;
    "toolkit.telemetry.updatePing.enabled" = false;
    "toolkit.telemetry.bhrPing.enabled" = false;
    "toolkit.telemetry.firstShutdownPing.enabled" = false;
    "browser.ping-centre.telemetry" = false;
    "app.shield.optoutstudies.enabled" = false;
    "app.normandy.enabled" = false;
    "app.normandy.api_url" = "";
    "breakpad.reportURL" = "";
    "browser.tabs.crashReporting.sendReport" = false;

    # Security / DNS
    "network.trr.mode" = 3;
    "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";

    # --- GENERAL & UI ---
    "browser.privatebrowsing.autostart" = false;
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "svg.context-properties.content.enabled" = true;
    "browser.download.useDownloadDir" = true;

    # --- THEME (Force Dark Mode) ---
    "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
    "ui.systemUsesDarkTheme" = 1;
    "devtools.theme" = "dark";
    "layout.css.prefers-color-scheme.content-override" = 0;
  };
}
