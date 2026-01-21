{ config, pkgs, ... }:
let
  user = config.userConfig.darwin.username;
in
{
  imports = [
    ../modules/darwin/home-manager.nix
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
          { app = "/Applications/Obsidian.app"; }
          { app = "/Applications/Telegram.app"; }
          { app = "/Users/tiefenbacher/Applications/Slack.app"; }
          { app = "/System/Applications/Music.app"; }
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
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
