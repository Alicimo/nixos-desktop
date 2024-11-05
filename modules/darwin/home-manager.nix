{ config, pkgs, lib, home-manager, ... }:

let
  user = "tiefenbacher";
in
{
  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    # This is a module from nix-darwin
    # Homebrew is *installed* via the flake input nix-homebrew
    enable = true;
    casks = pkgs.callPackage ./casks.nix {};
    global = {
      autoUpdate = true;
    };
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }:{
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        stateVersion = "23.11";
      };

      programs = {} // import ../shared/home-manager.nix { inherit config pkgs lib; };

      home.activation =
      let
        configPath = "/Users/tiefenbacher/Library/Application\ Support/Code/User/settings.json";
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
  };

}