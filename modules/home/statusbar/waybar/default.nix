{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.statusbar.waybar;
in {
  options.nkm.statusbar.waybar = {
    enable = lib.mkEnableOption "Waybar Status Bar";
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;

      # Let systemd handle the startup (ties into graphical-session.target)
      systemd.enable = true;

      # Load the CSS file from the same directory
      style = builtins.readFile ./style.css;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          mod = "dock";
          exclusive = true;
          passthrough = false;
          gtk-layer-shell = true;
          height = 32;

          # Your modules
          modules-left = ["niri/workspaces" "niri/window"];
          modules-center = ["clock" "custom/notification"];
          modules-right = ["tray" "pulseaudio" "network" "battery"];

          # --- Module Configurations (Copied from your old config) ---
          "custom/notification" = {
            tooltip = false;
            format = "{icon}";
            format-icons = {
              notification = "<span foreground='red'><sup></sup></span>";
              none = "";
              dnd-notification = "<span foreground='red'><sup></sup></span>";
              dnd-none = "";
              inhibited-notification = "<span foreground='red'><sup></sup></span>";
              inhibited-none = "";
              dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
              dnd-inhibited-none = "";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw";
            escape = true;
          };

          "niri/workspaces" = {
            format = "{icon}";
            format-icons = {
              active = "";
              default = "";
            };
          };

          "niri/window" = {
            format = "{title}";
            max-length = 35;
            separate-outputs = true;
          };

          "clock" = {
            format = "{:%H:%M}";
            format-alt = "{:%A, %B %d, %Y (%R)}";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
          };

          "pulseaudio" = {
            format = "{icon}  {volume}%";
            format-muted = " Muted";
            on-click-right = "pulsemixer --toggle-mute";
            on-click = "alacritty -e pulsemixer";
            scroll-step = 5;
            format-icons = {
              headphone = "";
              default = ["" "" ""];
            };
          };

          "network" = {
            format-wifi = "  {signalStrength}%";
            format-ethernet = "󰈀 Connected";
            tooltip = false;
            format-linked = "{ifname} (No IP)";
            format-disconnected = "Disconnected ⚠";
            on-click = "alacritty -e nmtui";
          };

          "battery" = {
            states = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = " {capacity}%";
            format-plugged = " {capacity}%";
            format-icons = ["" "" "" "" ""];
          };

          "tray" = {
            icon-size = 16;
            spacing = 10;
          };
        };
      };
    };
  };
}
