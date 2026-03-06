{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.brave;
in {
  options.modules.brave = {
    enable = lib.mkEnableOption "brave browser";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.brave ];
  };
}
