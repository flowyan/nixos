{
  pkgs,
  lib,
  config,
  ...
}:
# Desktop environment support modules
# TODO needs cleanup! ideally sync desktop config with home-manager; if not, at
# least consolidate display protocol and desktop environment options
let
  cfg = config.modules.desktops;
in {
  imports = [
    ./dbus.nix
  ];

  options = {
    modules.desktops = {
      # enable/disable specific desktop environments and related packages
      wayland.enable = lib.mkEnableOption "enable Wayland desktop environments";
      xorg.enable = lib.mkEnableOption "enable X.org desktop environments";
    };
  };

  config = {
    # NOTE It seems that tuigreet cannot be used as the display manager, at
    # least out-of-the-box. NixOS expects the session to be wrapped with
    # services.displayManager.sessionData.wrapper in order to start the fake
    # graphical-session.target, but this is not done in the greetd NixOS module
    # (unlike the modules for other display managers). There might be some way
    # to use the --xsession-wrapper flag, but this doesn't seem to work by
    # passing the wrapper directly.

    # For now, use lightdm (gtk greeter) as the display manager
    #services.xserver.displayManager.lightdm = {
    #  enable = true;
    #  greeters.gtk = {
    #    enable = true;
    #  };
    #};

    services.displayManager.sddm = {
      enable = true;
      wayland = {
        enable = true;
        compositor = "kwin";
      };
      settings = {
        # kwin doesn't pick up cursor theme from [Theme] in Wayland mode;
        # must be set via the greeter environment instead
        Theme.CursorTheme = "Posy_Cursor_Black";
        General.GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=layer-shell,XCURSOR_THEME=Posy_Cursor_Black,XCURSOR_SIZE=24";
      };
    };

    # Restart SDDM after logout so the greeter comes back
    systemd.services.sddm.serviceConfig = {
      Restart = "always";
      RestartSec = 1;
    };

    # ALL DESKTOPS =============================================================

    security.polkit.enable = true;
    programs.dconf.enable = true;
    environment.systemPackages = [
      pkgs.polkit_gnome # gui for interactive authentication
      pkgs.posy-cursors # cursor theme for sddm
    ];

    # from https://discourse.nixos.org/t/xdg-desktop-portal-gtk-desktop-collision/35063
    # xdg desktop portals expose d-bus interfaces for xdg file access
    # are needed by some containerized apps like firefox.
    xdg.portal = {
      enable = true;
      wlr.enable = cfg.wayland.enable;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config = let wayland-conf = {
        default = [ "gtk" ];
        #... except for the ScreenCast, Screenshot and Secret
        "org.freedesktop.impl.portal.ScreenCast" = "wlr";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
        # ignore inhibit bc gtk portal always returns as success,
        # despite sway/the wlr portal not having an implementation,
        # stopping firefox from using wayland idle-inhibit
        "org.freedesktop.impl.portal.Inhibit" = "none";
      }; in lib.mkIf cfg.wayland.enable {
        niri = wayland-conf;
        sway = wayland-conf;
      };
      configPackages = [
        (lib.mkIf cfg.wayland.enable pkgs.niri)
        (lib.mkIf cfg.xorg.enable pkgs.xfce.xfce4-session)
      ];
    };

     # XORG =====================================================================

    services.xserver = {
      enable = cfg.xorg.enable;
      # enable startx to start X server sessions
      displayManager.startx.enable = cfg.xorg.enable;
      # add XFCE to the display manager
      desktopManager.session = lib.mkIf cfg.xorg.enable [{
        name = "xfce";
        prettyName = "Xfce";
        desktopNames = [ "XFCE" ];
        bgSupport = true;
        start = ''
          ${pkgs.runtimeShell} ${pkgs.xfce.xfce4-session.xinitrc} &
          waitPID=$!
        '';
      }];
      # update the DBus environment after launching the session
      updateDbusEnvironment = cfg.xorg.enable;
    };

    # Window manager only sessions (unlike DEs) don't handle XDG
    # autostart files, so force them to run the service
    services.xserver.desktopManager.runXdgAutostartIfNone = true;

    # WAYLAND ==================================================================

    # enable sway system-wide (PAM, polkit, etc.)
    programs.sway.enable = cfg.wayland.enable;

    # make sessions visible in display manager
    services.displayManager.sessionPackages =
      lib.optionals cfg.wayland.enable [ pkgs.niri pkgs.sway ];
  };
}
