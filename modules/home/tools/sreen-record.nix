{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.tools.screenRecord;

  recorderScript = pkgs.writeShellScriptBin "screen-record" ''
    if pgrep -f "gpu-screen-recorder" > /dev/null; then
        pkill -INT -f "gpu-screen-recorder"
        ${pkgs.libnotify}/bin/notify-send "Recorder" "Recording stopped" -i video-display
    else
        RECORD_DIR="$HOME/Videos/recordings"
        mkdir -p "$RECORD_DIR"
        TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        TEMP_FILE="$RECORD_DIR/temp_$TIMESTAMP.mp4"
        FINAL_FILE="$RECORD_DIR/rec_$TIMESTAMP.mp4"

        ${pkgs.libnotify}/bin/notify-send "Recorder" "Recording started..." -i video-display

        (
            gpu-screen-recorder \
              -w portal \
              -f 30 \
              -a default_output \
              -a default_input \
              -o "$TEMP_FILE"

            # Mix audio channels
            ${pkgs.ffmpeg}/bin/ffmpeg -i "$TEMP_FILE" \
              -filter_complex "[0:a:0][0:a:1]amix=inputs=2:duration=longest[a]" \
              -map 0:v -map "[a]" \
              -c:v copy -c:a aac \
              "$FINAL_FILE"

            rm "$TEMP_FILE"
            ${pkgs.libnotify}/bin/notify-send "Recorder" "Saved: $(basename "$FINAL_FILE")" -i video-display
        ) &
    fi
  '';
in {
  options.nkm.tools.screenRecord = {
    enable = lib.mkEnableOption "Screen Record Script (GPU Accelerated)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      recorderScript
      pkgs.ffmpeg
    ];
  };
}
