{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = { self, nix-darwin, nix-homebrew, homebrew-bundle, homebrew-core, homebrew-cask, home-manager, nixpkgs, nixpkgs-unstable } @inputs:
    let
      user = "tiefenbacher";
    in {
      darwinConfigurations."tiefenbacher-macbook" = nix-darwin.lib.darwinSystem {
        modules = [
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew {
            nix-homebrew = {
              inherit user;
              enable = true;
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "homebrew/homebrew-bundle" = homebrew-bundle;
              };
              mutableTaps = false;
              autoMigrate = true;
            };
          }
          ./hosts/darwin.nix
        ];
      };
    };
  }

    # let
    #   system = "x86_64-linux";
    #   overlay-unstable = final: prev: {
    #     unstable = import nixpkgs-unstable {
    #       inherit system;
    #       config.allowUnfree = true;
    #       config.rocmSupport = true;
    #     };
    #   };
    # in {
    #   nixosConfigurations.odin = nixpkgs.lib.nixosSystem {
    #     inherit system;
    #     modules = [
    #       ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
    #       ./configuration.nix
    #       home-manager.nixosModules.home-manager {
    #         home-manager.useGlobalPkgs = true;
    #         home-manager.useUserPackages = true;
    #         home-manager.users.alistair = import ./home/home.nix;
    #       }
    #     ];
    #   };
    # };
