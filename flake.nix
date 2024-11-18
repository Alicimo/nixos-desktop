{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
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
    homebrew-krtirtho = {
      url = "github:krtirtho/homebrew-apps";
      flake = false;
    };
  };

  outputs = { self, nix-darwin, nix-homebrew, homebrew-bundle, homebrew-core, homebrew-cask, homebrew-krtirtho, home-manager, nixpkgs, nixpkgs-stable }@inputs:
  {
    darwinConfigurations."tiefenbacher-macbook" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit inputs; };
      modules = [
        {
          nixpkgs.overlays = [
            (final: prev: {
              stable =
                import inputs.nixpkgs-stable { system = prev.system; };
            })
          ];
        }
        home-manager.darwinModules.home-manager {
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
        }
        nix-homebrew.darwinModules.nix-homebrew {
          nix-homebrew = {
            user = "tiefenbacher";
            enable = true;
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
              "homebrew/homebrew-krtirtho" = homebrew-krtirtho;
            };
            mutableTaps = false;
            autoMigrate = true;
          };
        }
        ./hosts/darwin.nix
      ];
    };
    nixosConfigurations."tiefenbacher-desktop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.alistair = import ./modules/nixos/home-manager.nix;
            };
          }
          ./hosts/nixos
        ];
    };
  };
}
