{...}: {
  imports = [
    # Terminal
    ./terminal/alacritty.nix
    ./shell/zsh.nix
    ./prompt/starship.nix

    # Window Manager
    ./wm/niri

    # App Launcher
    ./launcher/walker

    # Status Bar & Services
    ./statusbar/waybar
    ./services/swaync
    ./services/hypridle.nix
    ./services/hyprlock.nix

    # Browser
    ./browser/firefox

    # Editor
    ./editor/nvim

    # Others
    ./programs/media.nix
    ./programs/gui.nix
    ./programs/tui.nix
    ./tools/nirishot.nix
    ./tools/sreen-record.nix
  ];
}
