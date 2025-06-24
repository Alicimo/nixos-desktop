{ config, pkgs, lib, ... }:

let
  userCfg = config.userConfig;
  user = userCfg.nixos.username;
  shared-programs = import ../shared/home-manager.nix { inherit config pkgs lib; };
in
{
  imports = [
    ./gnome.nix
  ];

  home = {
    enableNixpkgsReleaseCheck = false;
    username = "${user}";
    homeDirectory = userCfg.nixos.homeDirectory;
    packages = import ../shared/all-packages.nix { inherit pkgs; system = userCfg.nixos.system; };
    stateVersion = "23.11";

    # The vscode config be editable
    activation =
    let
      configPath = userCfg.paths.vscode.nixos;
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
      userName = userCfg.name;
      userEmail = userCfg.email.personal;
    };

    ghosttty = {
      enable = true;
      enableFishIntegration = true;
    };

    firefox = {
      enable = true;
      profiles."default" = {
        id = 0 ;
        isDefault = true;
        settings = {
          "browser.startup.homepage" = userCfg.services.homepage.nixos;
          "extensions.pocket.enabled" = false;
          "signon.rememberSignons" = false;
          "browser.newtabpage.enabled" = false;
          "browser.vpn_promo.enabled" = false;
          "identity.fxaccounts.enabled" = false;
        };
        search = {
          default = userCfg.services.search.nixos;
          force = true;
          engines = {
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
                template = userCfg.services.whoogle.nixos;
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
  };
}