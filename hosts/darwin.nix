{ config, pkgs, ... }:
let user = "tiefenbacher"; in
{
  imports = [
    ../modules/darwin/home-manager.nix
    ../modules/shared
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  # Setup user, packages, programs
  nix = {
    package = pkgs.nix;
    settings.trusted-users = [ "@admin" "${user}" ];

    gc = {
      user = "root";
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };

    # Turn this on to make command line easier
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Load configuration that is shared across systems
  environment.systemPackages = with pkgs; [
  ] ++ (import ../modules/shared/packages.nix { inherit pkgs; });

  system = {
    stateVersion = 4;

    defaults = {
      LaunchServices = {
        LSQuarantine = false;
      };

      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        ApplePressAndHoldEnabled = false;

        # 120, 90, 60, 30, 12, 6, 2
        KeyRepeat = 2;

        # 120, 94, 68, 35, 25, 15
        InitialKeyRepeat = 15;

        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.sound.beep.volume" = 0.0;
        "com.apple.sound.beep.feedback" = 0;
      };

      dock = {
        autohide = true;
        show-recents = false;
        launchanim = true;
        mouse-over-hilite-stack = true;
        orientation = "bottom";
        tilesize = 48;
        mru-spaces = false;
      };

      finder = {
        AppleShowAllExtensions = true;
        FXPreferredViewStyle = "clmv";
        ShowPathbar = true;
      };

      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };

      screensaver.askForPasswordDelay = 10;
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };

nixpkgs.hostPlatform = "aarch64-darwin";
security.pam.enableSudoTouchIdAuth = true;

}