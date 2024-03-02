# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports = [
      ./hardware-configuration.nix
      ./home/home.nix
      ./pkgs/default.nix
  ];

  # Bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
    };
  };
  time.hardwareClockInLocalTime = true;

  # Networking
  networking = {
    hostName = "odin";
    networkmanager.enable = true;
    firewall.enable = false;
  };
  services.tailscale.enable = true;
  
  #Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    excludePackages = [ pkgs.xterm ];
  };

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = (with pkgs; [
    # gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    yelp
    gnome-calendar
    gnome-music
    gnome-maps
    gnome-weather
    gnome-contacts
    gnome-clocks
    simple-scan
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);

  systemd.tmpfiles.rules = [
    "d /home/alistair/workspace 0755 alistair users"
    "d /home/alistair/samba 0755 alistair users"
  ];
  fileSystems."/home/alistair/samba" = {
    device = "//tiefenbacher.home/public";
    fsType = "cifs";
    options = [ "guest,uid=1000,iocharset=utf8,_netdev" ];
  };

  # Localisation
  time.timeZone = "Europe/Vienna";
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

  # Enable CUPS to print documents.
  services.avahi = {
    enable = true;
    nssmdns = true;
  };
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alistair = {
    isNormalUser = true;
    description = "Alistair Tiefenbacher";
    extraGroups = [ "networkmanager" "wheel" "docker"];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "alistair";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.rocmSupport = true;

  services.borgbackup.jobs.workspace = {
    paths = "/home/alistair/workspace";
    encryption.mode = "none";
    environment.BORG_RSH = "ssh -i /home/alistair/.ssh/id_ed25519";
    repo = "ssh://tiefenbacher:22/mnt/data/backups/workspace";
    startAt = "*-*-* 12:00";
    prune.keep.daily = 7;
    user="alistair";
  };

  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
