{
  config,
  pkgs,
  lib,
  home-manager,
  ...
}:

let
  userCfg = config.userConfig;
  user = userCfg.darwin.username;
in
{
  users.users.${user} = {
    name = "${user}";
    home = userCfg.darwin.homeDirectory;
    isHidden = false;
    shell = pkgs.zsh;
  };

  programs.fish.enable = true;

  homebrew = {
    # This is a module from nix-darwin
    # Homebrew is *installed* via the flake input nix-homebrew
    enable = true;
    casks = pkgs.callPackage ./casks.nix { };
    brews = [
      "lightgbm" # for pycaret
    ];
    # masApps = { # Does not work
    #   "Spokenly" = 6740315592;
    # };
    global = {
      autoUpdate = true;
    };
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      let
        # Now userConfig is available via config.userConfig due to the import
        userCfg = config.userConfig;

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

        # Import shared configuration with platform context
        shared-config = import ../shared/home-manager.nix {
          inherit config pkgs lib;
          platform = "darwin";
        };
      in
      {
        imports = [
          # Import the user-config module so userConfig is available
          ../shared/user-config.nix
        ];

        home = {
          enableNixpkgsReleaseCheck = false;
          packages = import ../shared/all-packages.nix {
            inherit pkgs;
            system = userCfg.darwin.system;
          };
          stateVersion = "23.11";

          # VS Code activation using shared function
          activation = mkVSCodeActivation "darwin";
        };

        # Define a LaunchAgent to run hblock periodically
        launchd.agents.hblock = {
          enable = true;
          config = {
            Program = "${pkgs.hblock}/bin/hblock";
            StartInterval = 86400; # Run once per day
            StandardOutPath = "${userCfg.darwin.homeDirectory}/Library/Logs/hblock.log";
            StandardErrorPath = "${userCfg.darwin.homeDirectory}/Library/Logs/hblock-error.log";
          };
        };

        programs = shared-config // {
          ssh = shared-config.ssh // {
            includes = [ userCfg.paths.ssh.darwin ];
          };
          zsh = {
            enable = true;
            initContent = ''
              if [[ $(ps -o command= -p "$PPID" | awk '{print $1}') != 'fish' ]]
              then
                  exec fish -l
              fi
            '';
          };
        };
      };
  };
}
