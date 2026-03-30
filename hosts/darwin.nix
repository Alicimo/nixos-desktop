{ config, pkgs, ... }:
let
  user = config.userConfig.darwin.username;
  nixApps = pkgs.buildEnv {
    name = "darwin-applications";
    paths = [
      pkgs.firefox-bin
    ];
    pathsToLink = "/Applications";
  };
in
{
  imports = [
    ../modules/darwin/home-manager.nix
    ../modules/darwin/tailscale-hosts.nix
    ../modules/shared
  ];

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  # Setup user, packages, programs
  nix = {
    enable = true;
  };

  system = {
    stateVersion = 4;

    primaryUser = user;

    defaults = {
      LaunchServices = {
        LSQuarantine = false;
      };

      NSGlobalDomain = {
        AppleInterfaceStyleSwitchesAutomatically = true;
        AppleShowAllExtensions = true;

        ApplePressAndHoldEnabled = false;
        KeyRepeat = 2;
        InitialKeyRepeat = 15;

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = true;
        show-recents = false;
        magnification = true;
        launchanim = true;
        mouse-over-hilite-stack = true;
        orientation = "bottom";
        tilesize = 48;
        largesize = 96;
        mru-spaces = false;
        persistent-apps = [
          { app = "/Applications/Visual Studio Code.app"; }
          { app = "/Applications/Ghostty.app"; }
          { app = "/Applications/Telegram.app"; }
          { app = "/Users/tiefenbacher/Applications/Slack.app"; }
          { app = "/Applications/Nix Apps/Firefox.app"; }
          { app = "/System/Applications/Mail.app"; }
          { app = "/System/Applications/Calendar.app"; }
          { app = "/System/Applications/Reminders.app"; }
          { app = "/Applications/NetNewsWire.app"; }
        ];
      };

      finder = {
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "Nlsv";
        ShowPathbar = true;
        ShowStatusBar = true;
        _FXShowPosixPathInTitle = true;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };

      screensaver.askForPasswordDelay = 10;
    };

    keyboard.enableKeyMapping = true;

    activationScripts.applications.text = ''
      mkdir -p /Applications/Nix\ Apps
      rm -rf /Applications/Nix\ Apps/Firefox.app
      ln -sfn "${nixApps}/Applications/Firefox.app" /Applications/Nix\ Apps/Firefox.app
    '';
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
