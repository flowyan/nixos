{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.kitty;
  font = config.utils.fonts.active.monospace;
  # base16-kitty color template, inlined from
  # https://github.com/kdrag0n/base16-kitty/blob/master/templates/default-256.mustache
  base16-kitty-template = builtins.readFile (pkgs.writeText "base16-kitty.mustache" ''
    background #{{base00-hex}}
    foreground #{{base05-hex}}
    selection_background #{{base05-hex}}
    selection_foreground #{{base00-hex}}
    url_color #{{base04-hex}}
    cursor #{{base05-hex}}
    cursor_text_color #{{base00-hex}}
    active_border_color #{{base03-hex}}
    inactive_border_color #{{base01-hex}}
    active_tab_background #{{base00-hex}}
    active_tab_foreground #{{base05-hex}}
    inactive_tab_background #{{base01-hex}}
    inactive_tab_foreground #{{base04-hex}}
    tab_bar_background #{{base01-hex}}
    wayland_titlebar_color #{{base00-hex}}
    color0  #{{base00-hex}}
    color1  #{{base08-hex}}
    color2  #{{base0B-hex}}
    color3  #{{base0A-hex}}
    color4  #{{base0D-hex}}
    color5  #{{base0E-hex}}
    color6  #{{base0C-hex}}
    color7  #{{base05-hex}}
    color8  #{{base03-hex}}
    color9  #{{base08-hex}}
    color10 #{{base0B-hex}}
    color11 #{{base0A-hex}}
    color12 #{{base0D-hex}}
    color13 #{{base0E-hex}}
    color14 #{{base0C-hex}}
    color15 #{{base07-hex}}
    color16 #{{base09-hex}}
    color17 #{{base0F-hex}}
    color18 #{{base01-hex}}
    color19 #{{base02-hex}}
    color20 #{{base04-hex}}
    color21 #{{base06-hex}}
  '');
in {
  options = {
    modules.kitty = {
      enable =
        lib.mkEnableOption "whether to enable the kitty configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = font.family;
        size = font.size;
        package = font.package;
      };
      settings = {
        window_padding_width = 6;
        initial_window_width = "55c";
        initial_window_height = "17c";
        cursor_shape = "block";
        # image support
        graphics_protocol = "kitty";
        allow_remote_control = "yes";
      };
      shellIntegration.enableZshIntegration = true;
      keybindings = {
        "ctrl+c" = "copy_and_clear_or_interrupt";
        "ctrl+v" = "paste_from_clipboard";
      };
      extraConfig = config.utils.mustache.eval-base16 base16-kitty-template;
    };
  };
}