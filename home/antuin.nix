{ config, pkgs, lib, ... }:
{
  home-manager.users.alistair = {
    programs.atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        update_check = false;
      };
    };
  };
}