{ config, ... }:

{
  # imports = [
  # ];

  config = {
    # configure keyboard to use colemak
    services.xserver = {
      xkb = {
        layout = "us";
        # variant = "colemak";
        # options = "caps:escape";
      };
    };
  };
}