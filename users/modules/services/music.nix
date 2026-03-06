{lib, ...}: {
  options.modules.music = {
    enable = lib.mkEnableOption "music";
  };
  # TODO: music configuration
}
