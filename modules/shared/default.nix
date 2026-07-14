{ config, pkgs, ... }:
{
  imports = [
    ./user-config.nix
    ./system.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };
  };
}
