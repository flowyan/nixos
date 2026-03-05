{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.kitty;
  # base16-kitty provides the mustache template for
  # the color scheme
  base16-kitty = "${inputs.base16-kitty}/templates/default-256.mustache";
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
      # package = pkgs.kitty-themes;
      # settings = {
      #   font.size = config.utils.fonts.active.monospace.size;
      #   general.import = let
      #     themeFile = pkgs.writeTextFile {
      #       name = "base16.toml";
      #       text = config.utils.mustache.eval-base16 (builtins.readFile base16-kitty);
      #     };
      #   in [themeFile];
      #   window = {
      #     padding = {
      #       x = 6;
      #       y = 6;
      #     };
      #     dimensions = {
      #       columns = 55;
      #       lines = 17;
      #     };
      #   };
      #   cursor.style.shape = "Block";
      #   terminal.shell = {
      #     program = "zsh";
      #     args = [
      #       "-c"
      #       "fastfetch && exec zsh"
      #     ];
      #   };
      # };
    };
  };
}