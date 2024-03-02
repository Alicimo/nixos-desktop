{ config, pkgs, lib, ... }:
{
  home-manager.users.alistair = {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
        gnomeExtensions.vitals
        gnomeExtensions.dash-to-panel
        gnomeExtensions.clipboard-history
        gnomeExtensions.alphabetical-app-grid
        gnomeExtensions.tiling-assistant
        gnomeExtensions.caffeine

        fira-code
        fira-code-symbols
        papirus-icon-theme
    ];
    dconf = {
      enable = true;
      settings = {
	      "org/gnome/shell" = {
          favorite-apps = [
            "chromium-browser.desktop"
            "thunderbird.desktop"
            "code.desktop"
            "org.gnome.Console.desktop"
            "org.gnome.Nautilus.desktop"
          ];
	        disable-user-extensions = false;
          enabled-extensions = [
            "AlphabeticalAppGrid@stuarthayhurst"
            "clipboard-history@alexsaveau.dev"
            "dash-to-panel@jderose9.github.com"
            "Vitals@CoreCoding.com"
            "tiling-assistant@leleat-on-github"
            "caffeine@patapon.info"
          ];
        };
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          enable-hot-corners = false;
	        monospace-font-name = "Fira Code 10";
	        icon-theme = "Papirus-Dark";
        };
        "org/gnome/desktop/background" = {
          picture-uri = "/home/alistair/samba/media/Photos/Wedding_dropbox/2020_12_19_Sophie & Alistair--140.jpg";
          picture-options = "zoom";
        };
        "org/gnome/mutter" = {
          edge-tiling = false; # turn off when using tiling assistant extension
          dynamic-workspaces = true;
          workspaces-only-on-primary = true;
        };
        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = true;
        };
        "org/gnome/shell/extensions/dash-to-panel" = {
          multi-monitors = true;
          panel-element-positions = ''
        {"0":[{"element":"activitiesButton","visible":true,"position":"stackedTL"},{"element":"leftBox","visible":false,"position":"stackedTL"},{"element":"showAppsButton","visible":true,"position":"centered"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":false,"position":"centered"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedTL"},{"element":"desktopButton","visible":false,"position":"stackedBR"}],"1":[{"element":"activitiesButton","visible":true,"position":"stackedTL"},{"element":"leftBox","visible":false,"position":"stackedTL"},{"element":"showAppsButton","visible":true,"position":"centered"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":false,"position":"centered"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedTL"},{"element":"desktopButton","visible":false,"position":"stackedBR"}]}
          '';
        };
        "org/gnome/shell/extensions/settings/vitals" = {
          hot-sensors = [
            "_processor_usage_"          
            "_memory_usage_"
            "__network-rx_max__" 
          ];
        };
        "org/gnome/desktop/search-providers" = {
          disable-external =  true;
        };
        "org/freedesktop/tracker/miner/files" = {
          index-recursive-directories = [];
          index-single-directories = [];
        };
      };
    };
  };
}