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


  # # Fully declarative dock using the latest from Nix Store
  # local = {
  #   dock.enable = true;
  #   dock.entries = [
  #     { path = "/Applications/Slack.app/"; }
  #     { path = "/System/Applications/Messages.app/"; }
  #     { path = "/System/Applications/Facetime.app/"; }
  #     { path = "/Applications/Telegram.app/"; }
  #     { path = "${pkgs.alacritty}/Applications/Alacritty.app/"; }
  #     { path = "/System/Applications/Music.app/"; }
  #     { path = "/System/Applications/News.app/"; }
  #     { path = "/System/Applications/Photos.app/"; }
  #     { path = "/System/Applications/Photo Booth.app/"; }
  #     { path = "/System/Applications/TV.app/"; }
  #     { path = "${pkgs.jetbrains.phpstorm}/Applications/PhpStorm.app/"; }
  #     { path = "/Applications/TablePlus.app/"; }
  #     { path = "/Applications/Asana.app/"; }
  #     { path = "/Applications/Drafts.app/"; }
  #     { path = "/System/Applications/Home.app/"; }
  #     {
  #       path = "${config.users.users.${user}.home}/.local/share/downloads";
  #       section = "others";
  #       options = "--sort name --view grid --display stack";
  #     }
  #   ];
  # };
}