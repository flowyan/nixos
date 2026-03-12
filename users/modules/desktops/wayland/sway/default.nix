{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  config = with inputs.nix-rice.lib.nix-rice; let
    colors = with inputs.nix-rice.lib.nix-rice; rec {
      accent = config.colorscheme.palette.base0D;
      accentMid =
        color.toRgbHex (color.darken 40
          (color.hexToRgba "#${accent}"));
      accentDark =
        color.toRgbHex (color.darken 80
          (color.hexToRgba "#${accent}"));
      accentLight =
        color.toRgbHex (color.brighten 20
          (color.hexToRgba "#${accent}"));
    };
  in
    lib.mkIf config.modules.desktops.wayland.enable {
      home.packages = with pkgs; [
        libinput-gestures
        xdotool # needed for browser back/forward via keyboard simulation
        swaybg
      ];

      # libinput-gestures config
      xdg.configFile."libinput-gestures.conf".text = ''
        # 3-finger swipe: browser back/forward (Alt+Left / Alt+Right)
        gesture swipe left  2 xdotool key alt+Right
        gesture swipe right 2 xdotool key alt+Left

        # 4-finger swipe: switch workspaces
        gesture swipe left  3 swaymsg workspace next
        gesture swipe right 3 swaymsg workspace prev

        # 3-finger pinch: zoom in/out
        # gesture pinch in  3 xdotool key ctrl+minus
        # gesture pinch out 3 xdotool key ctrl+equal
      '';

      wayland.windowManager.sway = {
        enable = true;
        systemd.enable = true;
        config = {
          startup = [
            # {
            #   command = "${pkgs.waybar}/bin/waybar";
            #   always = true;
            # }
            {
              command = "${pkgs.mako}/bin/mako --default-timeout 5000";
              always = true;
            }
            {
              command = "${pkgs.vesktop}/bin/vesktop --start-minimized";
            }
            {
              command = "${pkgs.libinput-gestures}/bin/libinput-gestures";
              always = true;
            }
          ];
          gaps = {
            inner = 5;
            outer = 5;
            smartGaps = true;
          };
          window.border = 1;
          defaultWorkspace = "workspace number 1";
          modifier = "Mod5";
          floating.modifier = "Mod5";
          terminal = "kitty";
          output = {
            "eDP-1" = {
              mode = "3024x1890@120Hz";
              scale = "1.5";
              position = "712,1440";
            };
            "HDMI-A-1" = {
              mode = "3440x1440@100Hz";
              scale = "1";
              position = "0,0";
            };
          };
          focus.followMouse = false;
          bars = [{
            position = "bottom";
            statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-sway.toml";
            trayOutput = "none";
            colors = let
              p = config.colorscheme.palette;
            in {
              background = "#${p.base00}";
              statusline = "#${p.base05}";
              separator = "#${p.base03}";
              focusedWorkspace = {
                background = "#${p.base0D}";
                border = "#${p.base0D}";
                text = "#${p.base00}";
              };
              activeWorkspace = {
                background = "#${p.base02}";
                border = "#${p.base02}";
                text = "#${p.base05}";
              };
              inactiveWorkspace = {
                background = "#${p.base01}";
                border = "#${p.base01}";
                text = "#${p.base04}";
              };
              urgentWorkspace = {
                background = "#${p.base08}";
                border = "#${p.base08}";
                text = "#${p.base00}";
              };
            };
          }];
          input = {
            "*" = {
              xkb_layout = "us";
              # xkb_variant = "colemak";
              # xkb_options = "caps:escape";
            };
            "type:touchpad" = {
              natural_scroll = "enabled";
              tap = "disabled";
              dwt = "disabled";
            };
          };
          menu = "${pkgs.fuzzel}/bin/fuzzel";

          # Make these correct so its not for colemak :v
          left = "h";
          down = "n";
          up = "e";
          right = "i";

          keybindings = let
            cfg = config.wayland.windowManager.sway.config;
            modifier = cfg.modifier;
          in {
            # Apps
            "${modifier}+Return" = "exec ${cfg.terminal}";
            "${modifier}+w" = "exec brave";
            "${modifier}+o" = "exec emacsclient --create-frame";
            "${modifier}+e" = "exec ${pkgs.xfce.thunar}/bin/thunar";
            "${modifier}+Space" = "exec ${cfg.menu}";

            # Window management
            "${modifier}+q" = "kill";
            "${modifier}+f" = "fullscreen toggle";
            "${modifier}+Shift+Space" = "floating toggle";
            "${modifier}+Shift+f" = "focus mode_toggle";
            "${modifier}+a" = "focus parent";
            "${modifier}+j" = "layout toggle split";
            "${modifier}+p" = "layout toggle split";
            "${modifier}+k" = "layout stacking";
            "${modifier}+b" = "layout tabbed";

            # Focus - arrow keys
            "${modifier}+Left" = "focus left";
            "${modifier}+Down" = "focus down";
            "${modifier}+Up" = "focus up";
            "${modifier}+Right" = "focus right";
            # Move - arrow keys
            "${modifier}+Shift+Left" = "move left";
            "${modifier}+Shift+Down" = "move down";
            "${modifier}+Shift+Up" = "move up";
            "${modifier}+Shift+Right" = "move right";

            # Workspaces
            "${modifier}+1" = "workspace number 1";
            "${modifier}+2" = "workspace number 2";
            "${modifier}+3" = "workspace number 3";
            "${modifier}+4" = "workspace number 4";
            "${modifier}+5" = "workspace number 5";
            "${modifier}+6" = "workspace number 6";
            "${modifier}+7" = "workspace number 7";
            "${modifier}+8" = "workspace number 8";
            "${modifier}+9" = "workspace number 9";
            "${modifier}+0" = "workspace number 10";

            # Move to workspace
            "${modifier}+Shift+1" = "move container to workspace number 1";
            "${modifier}+Shift+2" = "move container to workspace number 2";
            "${modifier}+Shift+3" = "move container to workspace number 3";
            "${modifier}+Shift+4" = "move container to workspace number 4";
            "${modifier}+Shift+5" = "move container to workspace number 5";
            "${modifier}+Shift+6" = "move container to workspace number 6";
            "${modifier}+Shift+7" = "move container to workspace number 7";
            "${modifier}+Shift+8" = "move container to workspace number 8";
            "${modifier}+Shift+9" = "move container to workspace number 9";
            "${modifier}+Shift+0" = "move container to workspace number 10";

            # Scratchpad
            "${modifier}+Shift+s" = "move scratchpad";
            "${modifier}+s" = "scratchpad show";

            # System
            "${modifier}+Shift+c" = "reload";
            "${modifier}+Shift+e" = "exec ${pkgs.wlogout}/bin/wlogout";
            "${modifier}+r" = "mode resize";
          };

          colors = {
            # TODO set gray colors with config too!
            # TODO also could modify this based on light or dark theme
            focused = {
              border = colors.accentDark;
              childBorder = "#333333";
              background = colors.accentMid;
              indicator = colors.accent;
              text = "#ffffff";
            };
            focusedInactive = {
              background = "#5f676a";
              childBorder = "#333333";
              border = "#333333";
              indicator = "#484e50";
              text = "#ffffff";
            };
          };
        };

        # TODO verify clamshell mode works
        extraConfig = ''
          output "*" bg ${../../wallpapers/houby.jpg} stretch

          # Volume
          bindsym XF86AudioRaiseVolume exec '${pkgs.pamixer}/bin/pamixer -i 5 && paplay ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/audio-volume-change.oga'
          bindsym XF86AudioLowerVolume exec '${pkgs.pamixer}/bin/pamixer -d 5 && paplay ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/audio-volume-change.oga'
          bindsym XF86AudioMute exec '${pkgs.pamixer}/bin/pamixer -t'
          bindsym XF86AudioMicMute exec '${pkgs.pamixer}/bin/pamixer --default-source -t'

          # Media keys
          bindsym XF86AudioPlay exec '${pkgs.playerctl}/bin/playerctl play-pause'
          bindsym XF86AudioPause exec '${pkgs.playerctl}/bin/playerctl play-pause'
          bindsym XF86AudioNext exec '${pkgs.playerctl}/bin/playerctl next'
          bindsym XF86AudioPrev exec '${pkgs.playerctl}/bin/playerctl previous'

          # Brightness
          bindsym XF86MonBrightnessDown exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-
          bindsym XF86MonBrightnessUp exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%+

          # Keyboard Backlight
          bindsym ${config.wayland.windowManager.sway.config.modifier}+XF86MonBrightnessDown exec ${pkgs.brightnessctl}/bin/brightnessctl --device='kbd_backlight' set 5%-
          bindsym ${config.wayland.windowManager.sway.config.modifier}+XF86MonBrightnessUp exec ${pkgs.brightnessctl}/bin/brightnessctl --device='kbd_backlight' set 5%+

          bindsym XF86PowerOff exec ${pkgs.wlogout}/bin/wlogout

          # Clamshell mode
          set $laptop eDP-1
          bindswitch --reload --locked lid:on output $laptop disable
          bindswitch --reload --locked lid:off output $laptop enable

          # Scroll through workspaces
          bindsym --whole-window ${config.wayland.windowManager.sway.config.modifier}+button4 workspace prev
          bindsym --whole-window ${config.wayland.windowManager.sway.config.modifier}+button5 workspace next
        '';
      };

      programs.i3status-rust = let
        p = config.colorscheme.palette;
      in {
        enable = true;
        bars.sway = {
          icons = "none";
          theme = "plain";
          settings.theme.overrides = {
            idle_bg      = "#${p.base00}";
            idle_fg      = "#${p.base05}";
            good_bg      = "#${p.base00}";
            good_fg      = "#${p.base0B}";
            degraded_bg  = "#${p.base00}";
            degraded_fg  = "#${p.base0A}";
            bad_bg       = "#${p.base00}";
            bad_fg       = "#${p.base08}";
            info_bg      = "#${p.base00}";
            info_fg      = "#${p.base0D}";
            separator_bg = "#${p.base00}";
            separator    = "  ";
          };
          blocks = [
            {
              block = "net";
              device = "wlp1s0f0";
              format = "{$ssid $signal_strength $ip|}";
              inactive_format = "down";
              missing_format = "missing";
            }
            {
              block = "battery";
              driver = "upower";
              device = "macsmc-battery";
              format = "bat $percentage {$time_remaining.dur(hms:true,min_unit:m) |}";
              charging_format = "chr $percentage {$time_remaining.dur(hms:true,min_unit:m) |}";
              full_format = "bat full";
              warning = 20;
              critical = 10;
            }
          ];
        };
      };
    };
}
