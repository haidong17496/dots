{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nkm.programs.hyprlock;

  # --- CONFIGURATION ---
  scale = 1.0;

  wallpaper = ../../../images/wallpaper.png;

  font_family = "JetBrainsMono Nerd Font";
  base_font_size = 18;

  S = x: builtins.toString (builtins.floor (x * scale));

  base_offset_x = -300;

  pos_x_0 = base_offset_x;
  pos_x_1 = base_offset_x + 50;
  pos_x_2 = base_offset_x + 100;
in {
  options.nkm.programs.hyprlock = {
    enable = lib.mkEnableOption "Hyprlock (Rust-themed Screen Locker)";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          hide_cursor = true;
          no_fade_in = false;
          grace = 0;
          disable_loading_bar = true;
        };

        # --- BACKGROUND ---
        background = [
          {
            monitor = "";
            path = "${wallpaper}";
            blur_passes = 2;
            blur_size = 4;
            brightness = 0.5;
          }
        ];

        input-field = [
          {
            size = "${S 300}, ${S (base_font_size * 2 + 10)}";
            position = "${S pos_x_2}, -10";
            monitor = "";
            dots_center = false;
            dots_spacing = 0.2;
            dots_size = 0.8;
            fade_on_empty = false;

            inner_color = "rgba(0, 0, 0, 0)";
            outer_color = "rgba(0, 0, 0, 0)";
            font_color = "rgb(166, 227, 161)";

            placeholder_text = "";
            check_color = "rgb(137, 180, 250)";
            fail_color = "rgb(243, 139, 168)";

            halign = "center";
            valign = "center";
            zindex = 10;
          }
        ];

        # --- LABELS (RUST SYNTAX HIGHLIGHTING) ---
        label = [
          # 1. TIME (let time = "HH:MM";)
          {
            text = "cmd[update:1000] echo \"<span foreground='##cba6f7'>let</span> time <span foreground='##89b4fa'>=</span> <span foreground='##a6e3a1'>\\\"$(date +'%H:%M')\\\"</span><span foreground='##89b4fa'>;</span>\"";
            color = "rgb(205, 214, 244)";
            font_size = S base_font_size;
            font_family = "${font_family} Bold";
            position = "${S pos_x_0}, ${S 140}";
            halign = "center";
            valign = "center";
          }

          # 2. DATE (let date = "Day, Month DD";)
          {
            text = "cmd[update:1000] echo \"<span foreground='##cba6f7'>let</span> date <span foreground='##89b4fa'>=</span> <span foreground='##a6e3a1'>\\\"$(date +'%A, %B %d')\\\"</span><span foreground='##89b4fa'>;</span>\"";
            color = "rgb(205, 214, 244)";
            font_size = S base_font_size;
            font_family = "${font_family} Bold";
            position = "${S pos_x_0}, ${S 110}";
            halign = "center";
            valign = "center";
          }

          # 3. CLASS DEFINITION (impl Developer for Nekoma {)
          {
            text = "<span foreground='##cba6f7'>impl</span> <span foreground='##fab387'>Developer</span> <span foreground='##cba6f7'>for</span> <span foreground='##89b4fa'>Nekoma</span> {";
            color = "rgb(205, 214, 244)";
            font_size = S base_font_size;
            font_family = "${font_family} Bold";
            position = "${S pos_x_0}, ${S 70}";
            halign = "center";
            valign = "center";
          }

          # 4. WRAPPER OPEN (your_password = Secret::new(r##")
          {
            text = "<span foreground='##fab387'>your_password</span> <span foreground='##89b4fa'>=</span> <span foreground='##fab387'>Secret</span>::<span foreground='##89b4fa'>new</span>(<span foreground='##a6e3a1'>r##&quot;</span>";
            color = "rgb(205, 214, 244)";
            font_size = S base_font_size;
            font_family = "${font_family} Bold";
            position = "${S pos_x_1}, ${S 30}";
            halign = "center";
            valign = "center";
          }

          # 5. WRAPPER CLOSE ("##);)
          {
            text = "<span foreground='##a6e3a1'>&quot;##</span>);";
            color = "rgb(205, 214, 244)";
            font_size = S base_font_size;
            font_family = "${font_family} Bold";
            position = "${S pos_x_1}, ${S (-50)}";
            halign = "center";
            valign = "center";
          }

          # 6. QUOTE (println!("Stay Hungry...");)
          {
            text = "<span foreground='##f38ba8'>println!</span>(<span foreground='##a6e3a1'>&quot;Stay Hungry, Stay Foolish!&quot;</span>);";
            color = "rgb(205, 214, 244)";
            font_size = S base_font_size;
            font_family = "${font_family} Italic";
            position = "${S pos_x_1}, ${S (-90)}";
            halign = "center";
            valign = "center";
          }

          # 7. CLOSING BRACE (})
          {
            text = "}";
            color = "rgb(205, 214, 244)";
            font_size = S base_font_size;
            font_family = "${font_family} Bold";
            position = "${S pos_x_0}, ${S (-130)}";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };
  };
}
