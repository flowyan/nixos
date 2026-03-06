{lib, ...}: {
  options.modules.mail = {
    enable = lib.mkEnableOption "mail";
  };
  # TODO: mail configuration
}
