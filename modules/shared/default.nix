{ config, pkgs, ... }:
{
  imports = [
    ./user-config.nix
    ./system.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };
  };
}
