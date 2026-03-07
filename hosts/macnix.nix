{ pkgs, lib, config, ... }:

{
  # Networking
  networking.hostName = "macnix";
  networking.networkmanager.enable = true;

  # Desktop support
  modules.desktops.xorg.enable = true;
  modules.desktops.wayland.enable = true;

  # zsh must be enabled at the system level to be a valid login shell
  programs.zsh.enable = true;

  # Configure users
  users.mutableUsers = false;
  users.users.ant = {
    hashedPassword = "$y$j9T$hnHLdn2h1cwef4KSAxRNZ/$z8xGgxx6O8F6m/vyfN4RiCv8U4Q8LAqIJF0FD0JTviB";
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager" # Allow the user to access the network manager
      "audio" # Needed for supercollider/tidal
      "jackaudio" # Needed for services.jack (I think)
      "video"
      "input" # above needed for brightnessctl
      "docker"
      # something to do with pio
      "uucp"
      "lock"
    ];
  };

  # Configure system packages
  # STYLE: This should only contain packages necessary for commands/services
  #  run as root, or for system recovery in an emergency. All other packages
  #  should be configured via home-manager on a per-user basis
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  ## todo: might want ladybird in the future :v
  # This has to go here for some reason
  # programs.ladybird.enable = true;

  # required udev rules for platformio
  services.udev.packages = [pkgs.platformio-core.udev pkgs.openocd];

  # virtualization
  virtualisation.docker.enable = true;
  # enable x86 emulation if we're on an aarch64 system
  boot.binfmt.emulatedSystems = lib.mkIf
    (config.platform.type == "aarch64-linux") ["x86_64-linux"];

  # For ` to < and ~ to > (for those with US keyboards)
  boot.extraModprobeConfig = ''
    options hid_apple iso_layout=0
  '';

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this
  # particular machine, and is used to maintain compatibility with application
  # data (e.g. databases) created on older NixOS versions. For more information,
  # see `man configuration.nix` or
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
