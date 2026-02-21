{...}: {
  imports = [
    # Terminal
    ./terminal/alacritty.nix
    ./shell/zsh.nix
    ./prompt/starship.nix

    # Window Manager
    ./wm/niri

    # UI & Theme
    ./theme

    # App Launcher
    ./launcher/walker

    # Status Bar & Services
    ./statusbar/waybar
    ./services/swaync
    ./services/hypridle.nix
    ./services/hyprlock.nix
    ./services/hyprpaper.nix

    # Browser
    ./browser/firefox

    # Editor
    ./editor/nvim

    # Others
    ./programs/common.nix
    ./programs/media.nix
    ./programs/gui.nix
    ./programs/tui.nix
    ./tools/nirishot.nix
    ./tools/sreen-record.nix
  ];
}
