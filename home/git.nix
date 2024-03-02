{ config, pkgs, lib, ... }:
{
  home-manager.users.alistair = {
    programs.git = {
      enable = true;
      lfs.enable = true;
      userName  = "Alistair Tiefenbacher";
      userEmail = "contact@alistair-martin.com";
      extraConfig = {
        merge.conflictstyle = "zdiff3";
        push.default = "current";
        init.defaultBranch = "main";
        diff.algorithm = "histogram";
      };
    };
  };
}