# Apple MacBook Pro M1 (2021, 14 inch)

{
  platform = {
    type = "aarch64-linux";
    asahi = true;

    # features (mainly graphics) available on this system
    available-features = {
      vsync = false;
      gamma-ramp = false;
      dp-alt-mode = false;
    };

    # internal keyboard information
    keyboard-management = {
      internal-kbd-name = "Apple SPI Keyboard";
    };

    # display and display profile information
    display-management = {
      displays = {
        eDP-1 = {
          fingerprint = "--CONNECTED-BUT-EDID-UNAVAILABLE--eDP-1";
          pixel-size.width = 3024;
          pixel-size.height = 1890;
          scale.xorg = 1.5;
          scale.wayland = 1.5;
        };
        HDMI-A-1 = {
          fingerprint = "00ffffffffffff00220e29370101010109200103805022782a0c35a9564d9b240d5054a10800d1c0b300a9c0d10095008180810081c04f7d70aad0a0295030203a00204f3100001a000000fd0030641e9b37000a202020202020000000fc004850205833340a202020202020000000ff0036434d323039304a355a0a202001e602033bf14710405a04030201230907078301000067030c001000384267d85dc401788000681a000001013064ede305e001e6060701605a33e200ebcc9d70aad0a0345030203a00204f3100001aefd470aad0a0465030203a00204f3100001a565e00a0a0a0295030203500204f3100001a000000000000000000000000000013";
          pixel-size.width = 3440;
          pixel-size.height = 1440;
          scale.xorg = 1.0;
          scale.wayland = 1.0;
        };
      };
      profiles.mobile = {
        eDP-1 = {
          primary = true;
          position = "0x0";
        };
      };
      profiles.docked = {
        eDP-1 = {
          position = "712x1440";
        };
        HDMI-A-1 = {
          primary = true;
          position = "0x0";
        };
      };
    };
  };
}
