{ config, lib, pkgs, ... }:
let
  gcCommon = {
    automatic = true;
    options = "--delete-older-than 30d";
  };
  trustedUser = if pkgs.stdenv.isDarwin then config.userConfig.darwin.username else config.userConfig.nixos.username;
in
{
  nix = {
    package = pkgs.nix;

    settings = {
      trusted-users = [
        "@admin"
        trustedUser
      ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';

    gc = gcCommon // (
      if pkgs.stdenv.isDarwin then {
        interval = {
          Weekday = 0;
          Hour = 2;
          Minute = 0;
        };
      } else {
        dates = "Sun 02:00";
      }
    );
  };

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
  ];

  services.tailscale.enable = true;
}
