{ config, ... }:

{
  # imports = [
  # ];

  config = {
    # apple_aluminium_iso: physical keyboard is ISO (Czech MBP 14"), software layout is US.
    # The ISO model tells XKB about the extra key between Shift and Z on ISO keyboards.
    # fnmode is set via hid_apple (see hosts/macnix.nix).
    services.xserver = {
      xkb = {
        model = "apple_aluminium_iso";
        layout = "us";
        # variant = "colemak";
        # options = "caps:escape";
      };
    };
  };
}