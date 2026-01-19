{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Now userConfig is available via config.userConfig due to the import
  userCfg = config.userConfig;
  user = userCfg.nixos.username;

  # Import shared programs with platform
  shared-programs = import ../shared/home-manager.nix {
    inherit config pkgs lib;
    platform = "nixos";
  };

  # VS Code activation function using userConfig
  mkVSCodeActivation =
    platform:
    let
      configPath = userCfg.paths.vscode.${platform};
    in
    {
      beforeCheckLinkTargets = {
        after = [ ];
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
in
{
  imports = [
    ./gnome.nix
    # Import the user-config module so userConfig is available
    ../shared/user-config.nix
  ];

  home = {
    enableNixpkgsReleaseCheck = false;
    username = user;
    homeDirectory = userCfg.nixos.homeDirectory;
    packages = import ../shared/all-packages.nix {
      inherit pkgs;
      system = userCfg.nixos.system;
    };
    stateVersion = "23.11";

    # VS Code activation using shared function
    activation = mkVSCodeActivation "nixos";
  };

  programs = shared-programs // {
    git = {
      settings.user = {
        name = userCfg.name;
        email = userCfg.email.personal;
      };
    };
  };
}
