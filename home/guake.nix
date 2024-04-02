{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    guake
  ];

  dconf.settings = {
    "apps/guake/general" = {
      start-at-login = true;
      use-trayicon = false;
      quick-open-command-line = "code -g %(file_path)s:%(line_number)s";
      quick-open-enable = true;
    };
    "/apps/guake/keybindings/global" = {
      show-hide = "F1";
    };
    "/apps/guake/keybindings/local" = {
      close-terminal = "<Primary>w";
      split-tab-vertical = "<Primary>equal";
      split-tab-horizontal= "<Primary>minus";
      focus-terminal-up = "<Primary>Up";
      focus-terminal-down = "<Primary>Down";
      focus-terminal-left = "<Primary>Left";
      focus-terminal-right = "<Primary>Right";
    };

    "apps/guake/style/background" = {
      transparency = 100;
    };
  };
}