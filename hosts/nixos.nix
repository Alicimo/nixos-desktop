# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  ...
}:
let
  userCfg = config.userConfig;
  user = userCfg.nixos.username;
in
{
  imports = [
    ../modules/shared
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [
        "amdgpu"
        "iwlwifi"
        "sg"
        "cifs"
      ];
    };
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        useOSProber = true;
        efiSupport = true;
      };
    };
    kernelModules = [
      "kvm-amd"
      "sg"
      "iwlwifi"
      "iwlmvm"
      "cifs"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [
        pkgs.rocmPackages.clr.icd
        pkgs.rocmPackages.clr
      ];
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/575c029b-feea-4deb-9583-9419861b3891";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/3D57-FA8E";
      fsType = "vfat";
    };
  };
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 2 * 1024;
    }
  ];

  systemd.tmpfiles.rules = [
    "d ${userCfg.nixos.homeDirectory}/workspace 0755 ${user} users"
    "d ${userCfg.nixos.homeDirectory}/samba 0755 ${user} users"
  ];
  fileSystems."${userCfg.nixos.homeDirectory}/samba" = {
    device = "//tiefenbacher.home/public";
    fsType = "cifs";
    options =
      let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in
      [ "${automount_opts},guest,uid=1000,vers=2.0" ]; # Removed _netdev, iocharset=utf8
  };

  nix = {
    settings = {
      trusted-users = [
        "@admin"
        "${user}"
      ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';
    optimise.automatic = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  # Networking
  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "odin";
    networkmanager.enable = true; # default for mamy DEs inc. GNOME
    firewall.enable = false;
  };

  # Localisation
  time = {
    timeZone = "Europe/Vienna";
    hardwareClockInLocalTime = true;
  };
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_AT.UTF-8";
      LC_IDENTIFICATION = "de_AT.UTF-8";
      LC_MEASUREMENT = "de_AT.UTF-8";
      LC_MONETARY = "de_AT.UTF-8";
      LC_NAME = "de_AT.UTF-8";
      LC_NUMERIC = "de_AT.UTF-8";
      LC_PAPER = "de_AT.UTF-8";
      LC_TELEPHONE = "de_AT.UTF-8";
      LC_TIME = "de_AT.UTF-8";
    };
  };

  services = {
    tailscale.enable = true;

    displayManager.autoLogin = {
      enable = true;
      user = "${user}";
    };

    # GNOME w/ X
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      excludePackages = [ pkgs.xterm ];
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Printing
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    printing = {
      enable = true;
      drivers = [ pkgs.brlaser ];
    };

    borgbackup.jobs.workspace = {
      paths = "${userCfg.nixos.homeDirectory}/workspace";
      encryption.mode = "none";
      environment.BORG_RSH = "ssh -i ${userCfg.nixos.homeDirectory}/.ssh/id_ed25519";
      repo = "ssh://tiefenbacher:22/mnt/data/backups/workspace";
      startAt = "*-*-* 12:00";
      prune.keep.daily = 7;
      user = user;
    };

    # llm
    ollama.enable = true;
    # open-webui.enable=true;
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };

  # Clean up Gnome
  environment.gnome.excludePackages = (
    with pkgs;
    [
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]
  );

  programs = {
    dconf.enable = true;
    zsh.enable = true;
    chromium = {
      enable = true;
      extraOpts = {
        "BrowserSignin" = 0;
        "SyncDisabled" = true;
        "PasswordManagerEnabled" = false;
        "SpellcheckEnabled" = true;
        "BrowserLabsEnabled" = false;
        "HighEfficiencyModeEnabled" = true;
        "NewTabPageLocation" = "http://tiefenbacher.home";
        "DefaultNotificationsSetting" = 2;
        "DefaultSearchProviderEnabled" = true;
        "DefaultSearchProviderName" = "Whoogle";
        "DefaultSearchProviderSearchURL" = "http://search.tiefenbacher.home/search?q={searchTerms}";
        "AutofillAddressEnabled" = false;
      };
    };
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      fira-code
      fira-code-symbols
    ];
  };

  security = {
    rtkit.enable = true; # Improves pipewire
    pam.services.gdm.enableGnomeKeyring = true; # autologin to keyring
  };

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  users.users.${user} = {
    isNormalUser = true;
    description = userCfg.name;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "cdrom"
    ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.rocmSupport = true;

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    cifs-utils

    clinfo
    rocmPackages.clr
    rocmPackages.hipblas
    rocmPackages.rocblas
    rocmPackages.rocm-smi
  ];

  system.stateVersion = "23.11"; # Never change this!
}
