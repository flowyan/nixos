{lib, ...}: {
  options.modules.rclone = {
    enable = lib.mkEnableOption "rclone";
  };
  # TODO: rclone configuration
}
