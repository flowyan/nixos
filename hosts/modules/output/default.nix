{config, ...}: {
  imports = [./displaylink.nix ./audio.nix];

  config = {
    # enable displaylink if DP altmode is not supported
    # modules.output.displaylink.enable = !config.platform.available-features.dp-alt-mode;
    modules.output.displaylink.enable = false; # theres some eula bullshit i have to do and dont care to do right now...
  };
}
