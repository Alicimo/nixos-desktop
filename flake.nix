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
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
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

  outputs =
    {
      self,
      nix-darwin,
      nix-homebrew,
      homebrew-bundle,
      homebrew-core,
      homebrew-cask,
      homebrew-krtirtho,
      home-manager,
      nixpkgs,
      nixpkgs-stable,
      nixpkgs-firefox-darwin,
      nixvim,
    }@inputs:
    let
      brewTaps = {
        "homebrew/homebrew-core" = homebrew-core;
        "homebrew/homebrew-cask" = homebrew-cask;
        "homebrew/homebrew-bundle" = homebrew-bundle;
        "homebrew/homebrew-krtirtho" = homebrew-krtirtho;
      };
    in
    {
      darwinConfigurations."tiefenbacher-macbook" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs brewTaps; };
        modules = [
          {
            nixpkgs.overlays = [
              (final: prev: {
                stable = import inputs.nixpkgs-stable { system = prev.system; };
              })
              inputs.nixpkgs-firefox-darwin.overlay
            ];
          }
          {
            homebrew.taps = builtins.attrNames brewTaps;
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
          }
          {
            home-manager.sharedModules = [
              nixvim.homeModules.nixvim
            ];
          }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              user = "tiefenbacher";
              enable = true;
              taps = brewTaps;
              mutableTaps = false;
              autoMigrate = true;
            };
          }
          ./hosts/darwin.nix
        ];
      };
      nixosConfigurations."tiefenbacher-desktop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          pkgs-stable = import nixpkgs-stable {
            config.allowUnfree = true;
          };
        };
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [
                nixvim.homeModules.nixvim
              ];
              users.alistair = import ./modules/nixos/home-manager.nix;
            };
          }
          ./hosts/nixos.nix
        ];
      };
    };
}
