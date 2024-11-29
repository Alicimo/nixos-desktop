{ config, pkgs, lib, ... }:

let
  name = "Alistair Tiefenbacher";
  user = "alistair";
  email = "contact@alistair-martin.com";
  shared-programs = import ../shared/home-manager.nix { inherit config pkgs lib; };
in
{
  imports = [
    ./gnome.nix
  ];

  home = {
    enableNixpkgsReleaseCheck = false;
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ./packages.nix {};
    stateVersion = "23.11";

    # The vscode config be editable
    activation =
    let
      configPath = "/home/alistair/.config/Code/User/settings.json";
    in
    {
      beforeCheckLinkTargets = {
        after = [];
        before = [ "checkLinkTargets" ];
        data = ''
          rm -f "${configPath}"
        '';
      };
      makeVSCodeConfigWritable = {
        after = [ "writeBoundary" ];
        before = [ ];
        data = ''
          install -m 0640 "$(readlink "${configPath}")" "${configPath}"
        '';
      };
    };
  };

  programs = shared-programs // {
    git = {
      userName = name;
      userEmail = email;
    };

    firefox = {
      enable = true;
      profiles."default" = {
        id = 0 ;
        isDefault = true;
        settings = {
          "browser.startup.homepage" = "http://tiefenbacher.home";
          "browser.search.defaultenginename" = "Whoogle";
        };
        search.engines = {
          "Nix Packages" = {
            definedAliases = [ "@np" ];
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";

          };
          "Nix Options" = {
            definedAliases = [ "@no" ];
            urls = [{
              template = "https://search.nixos.org/options";
              params = [
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
          };
          "Whoogle" = {
            urls = [{
              template = "http://search.tiefenbacher.home/search";
              params = [
                {name = "q"; value = "{searchTerms}"; }
              ];
            }];
          };
          "Google".metaData.alias = "@g";
        };
      };
    };
  };
}