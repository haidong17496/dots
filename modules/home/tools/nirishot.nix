{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.tools.nirishot;

  nirishotScript = pkgs.writeShellScriptBin "nirishot" ''
    # Dependencies
    GRIM="${pkgs.grim}/bin/grim"
    SLURP="${pkgs.slurp}/bin/slurp"
    WL_COPY="${pkgs.wl-clipboard}/bin/wl-copy"
    NOTIFY="${pkgs.libnotify}/bin/notify-send"
    JQ="${pkgs.jq}/bin/jq"
    NIRI="niri"

    XDG_PICTURES_DIR="$HOME/Pictures"
    SAVEDIR="''${XDG_PICTURES_DIR}/screenshots"
    mkdir -p "$SAVEDIR"

    FILENAME="$(date +'%Y-%m-%d-%H%M%S_nirishot.png')"
    FILEPATH="$SAVEDIR/$FILENAME"

    MODE="region"
    CLIPBOARD_ONLY=0

    while [[ $# -gt 0 ]]; do
      case $1 in
        -m|--mode) MODE="$2"; shift; shift ;;
        --clipboard-only) CLIPBOARD_ONLY=1; shift ;;
        *) shift ;;
      esac
    done

    if [[ "$MODE" == "region" ]]; then
        GEOMETRY=$($SLURP)
        if [ -z "$GEOMETRY" ]; then exit 1; fi

        if [ "$CLIPBOARD_ONLY" -eq 1 ]; then
            $GRIM -g "$GEOMETRY" - | $WL_COPY
            $NOTIFY "Nirishot" "Region copied to clipboard" -i camera-photo
        else
            $GRIM -g "$GEOMETRY" "$FILEPATH"
            $WL_COPY < "$FILEPATH"
            $NOTIFY "Nirishot" "Saved: $(basename "$FILEPATH")" -i "$FILEPATH"
        fi

    elif [[ "$MODE" == "window" ]]; then
        ACTIVE_OUTPUT=$($NIRI msg -j workspaces | $JQ -r 'first(.[] | select(.is_focused) | .output)')
        if [ -z "$ACTIVE_OUTPUT" ] || [ "$ACTIVE_OUTPUT" == "null" ]; then
            CAPTURE_CMD="$GRIM"
        else
            CAPTURE_CMD="$GRIM -o $ACTIVE_OUTPUT"
        fi

        if [ "$CLIPBOARD_ONLY" -eq 1 ]; then
            $CAPTURE_CMD - | $WL_COPY
            $NOTIFY "Nirishot" "Fullscreen copied to clipboard" -i video-display
        else
            $CAPTURE_CMD "$FILEPATH"
            $WL_COPY < "$FILEPATH"
            $NOTIFY "Nirishot" "Saved: $(basename "$FILEPATH")" -i "$FILEPATH"
        fi
    fi
  '';
in {
  options.nkm.tools.nirishot = {
    enable = lib.mkEnableOption "Nirishot (Screenshot tool for Niri)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      nirishotScript
      pkgs.grim
      pkgs.slurp
    ];
  };
}
