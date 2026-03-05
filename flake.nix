## thank you breitnw https://github.com/breitnw/nixos
{
  description = "flowyan's nixos config, based on some other configs i found";

  inputs = {
    # CORE (packages, system, etc) =============================================

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # apple silicon support modules
    apple-silicon-support = {
      url = "github:tpwrules/nixos-apple-silicon";
    };

    # PROGRAMS AND UTILS =======================================================

  };

  outputs = inputs: let
    # overlay for unstable packages, under the "unstable" attribute
    overlay-unstable = final: prev: {
      # instantiate nixpkgs-unstable to allow unfree packages
      unstable = import inputs.nixpkgs-unstable {
        inherit (prev.stdenv.hostPlatform) system;
        config.allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };

    # Configuration for each system NixOS/Home Manager will be deployed to.
    # A system, in my representation, is a pairing of a platform and a host.
    # See README for more information on platforms, hosts, and systems!
    systems = {
      core = {
        platform = ./platforms/macbook-pro-14in-m1pro/platform.nix;
        hardware-config = ./platforms/macbook-pro-14in-m1pro/hardware-configuration.nix;
        host-config = ./hosts/core.nix;
        user-config = ./users/ant-macnix.nix;
      };
    };
  in {
    # generate NixOS configurations for each system
    nixosConfigurations = builtins.mapAttrs (system-name: cfg:
      inputs.nixpkgs.lib.nixosSystem {
        # TODO Use the system name to generate rebuild commands so that it
        # doesn't need to be specified when system/hostname differ
        specialArgs = { inherit system-name inputs; };
        modules = [
          ({...}: {
            nixpkgs.overlays = [
              overlay-unstable
              # overlay-extra
            ];
          })

          # host configuration modules
          ./hosts/modules/common.nix
          # host configuration
          cfg.host-config
          # platform options module
          ./platforms/options.nix
          # platform configuration
          cfg.platform
          # hardware configuration
          cfg.hardware-config

          # Other dependencies
          inputs.nix-index-database.nixosModules.nix-index
          inputs.apple-silicon-support.nixosModules.default # only enabled on asahi
        ];
      }) systems;

    # generate home-manager configurations for each system
    homeConfigurations = inputs.nixpkgs.lib.mapAttrs' (system-name: cfg: {
      name = "ant@${system-name}";
      value = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages
          .${(import cfg.platform).platform.type};
        extraSpecialArgs = { inherit system-name inputs; };
        modules = [
          ({...}: {
            nixpkgs.overlays = [
              overlay-unstable
              # overlay-extra
              inputs.hackneyed.overlay
            ];
          })

          # home-manager configuration modules
          ./users/modules/common.nix
          # home-manager configuration
          cfg.user-config
          # platform options module
          ./platforms/options.nix
          # platform configuration
          cfg.platform

          # Other dependencies
          inputs.niri-flake.homeModules.niri
          inputs.hm-ricing-mode.homeManagerModules.hm-ricing-mode
        ];
      };
    }) systems;
  };
}
