# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Bootloader
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    useOSProber = true;
    efiSupport = true;
  };
  time.hardwareClockInLocalTime = true;

  # Networking
  networking = {
    hostName = "odin";
    networkmanager.enable = true;
    firewall.enable = false;
  };
  services.tailscale.enable = true;

  systemd.tmpfiles.rules = [
    "d /home/alistair/workspace 0755 alistair users"
    "d /home/alistair/samba 0755 alistair users"
  ];
  fileSystems."/home/alistair/samba" = {
    device = "//tiefenbacher/public";
    fsType = "cifs";
    options = [ "guest,uid=1000,iocharset=utf8" ];
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

  # Enable the X11 windowing system.
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

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
  home-manager.useGlobalPkgs = true;
  home-manager.users.alistair = {
    dconf = {
      enable = true;
      settings = {
	      "org/gnome/shell" = {
          favorite-apps = [
            "chromium-browser.desktop"
            "thunderbird.desktop"
            "code.desktop"
            "org.gnome.Console.desktop"
            "org.gnome.Nautilus.desktop"
          ];
	        disable-user-extensions = false;
          enabled-extensions = [
            "AlphabeticalAppGrid@stuarthayhurst"
            "clipboard-history@alexsaveau.dev"
            "dash-to-panel@jderose9.github.com"
            "Vitals@CoreCoding.com"
          ];
        };
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          enable-hot-corners = false;
	        monospace-font-name = "Fira Code 10";
	        icon-theme = "Papirus-Dark";
        };
        "org/gnome/desktop/background" = {
          picture-uri = "/home/alistair/samba/media/Photos/Wedding_dropbox/2020_12_19_Sophie & Alistair--140.jpg";
          picture-options = "zoom";
        };
        "org/gnome/mutter" = {
          edge-tiling = true;
          dynamic-workspaces = true;
          workspaces-only-on-primary = true;
        };
        "org/gnome/settings-daemon/plugins/color" = {
          night-light-enabled = true;
        };
        "org/gnome/shell/extensions/dash-to-panel" = {
          multi-monitors = true;
          panel-element-positions = ''
        {"0":[{"element":"activitiesButton","visible":true,"position":"stackedTL"},{"element":"leftBox","visible":false,"position":"stackedTL"},{"element":"showAppsButton","visible":true,"position":"centered"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":false,"position":"centered"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedTL"},{"element":"desktopButton","visible":false,"position":"stackedBR"}],"1":[{"element":"activitiesButton","visible":true,"position":"stackedTL"},{"element":"leftBox","visible":false,"position":"stackedTL"},{"element":"showAppsButton","visible":true,"position":"centered"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":false,"position":"centered"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedTL"},{"element":"desktopButton","visible":false,"position":"stackedBR"}]}
          '';
        };
        "org/gnome/shell/extensions/settings/vitals" = {
          hot-sensors = [
            "_processor_usage_"          
            "_memory_usage_"
            "__network-rx_max__" 
          ];
        };
      };
    };
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
        gnomeExtensions.vitals
        gnomeExtensions.dash-to-panel
        gnomeExtensions.clipboard-history
        gnomeExtensions.alphabetical-app-grid
        fira-code
        fira-code-symbols
        papirus-icon-theme

        thunderbird
        vlc
        duplicati
        libreoffice
	      rstudio
        ventoy-full

      	htop
        atop
        iotop
        unzip
	      wget
        curl
        imagemagick
        tree
        cifs-utils

        handbrake
        makemkv
	      abcde
	      flac
    ];
    programs.chromium = {
      enable =  true;
      extensions = [
	      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
	"fnaicdffflnofjppbagibeoednhnbjhg" # floccus bookmarks
	"hkgfoiooedgoejojocmhlaklaeopbecg" # Picture-in-Picture
        "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      ];
    };
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        pkief.material-icon-theme
        pkief.material-product-icons
        
        mechatroner.rainbow-csv
        grapecity.gc-excelviewer
        streetsidesoftware.code-spell-checker
        christian-kohler.path-intellisense
        ms-vscode-remote.remote-ssh
        
        jnoortheen.nix-ide
        mikestead.dotenv
        ms-azuretools.vscode-docker
        
        ms-python.python
        ms-python.isort
        ms-python.vscode-pylance
        ms-python.black-formatter
        
        ms-toolsai.jupyter
        ms-toolsai.vscode-jupyter-slideshow
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.jupyter-renderers
        ms-toolsai.jupyter-keymap
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "one-monokai";
          publisher = "azemoh";
          version = "0.5.0";
          sha256 = "ardM7u9lXkkTTPsDVqTl4yniycERYdwTzTQxaa4dD+c=";
        }
        {
          name = "vsc-python-indent";
          publisher = "KevinRose";
          version = "1.18.0";
          sha256 = "hiOMcHiW8KFmau7WYli0pFszBBkb6HphZsz+QT5vHv0=";
        }
      ];
      userSettings = {
        "editor.fontFamily" = "Fira Code";
        "editor.fontLigatures" = true;
        "editor.minimap.enabled" = false;
        "editor.overviewRulerBorder" = false;
        "files.autoSave" = "afterDelay";
        "editor.bracketPairColorization.independentColorPoolPerBracketType" = true;
        "workbench.colorTheme" = "One Monokai";
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.productIconTheme" = "material-product-icons";
        "window.titleBarStyle" = "custom";
      };
    };
    programs.git = {
      enable = true;
      lfs.enable = true;
      userName  = "Alistair Tiefenbacher";
      userEmail = "contact@alistair-martin.com";
    };
    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-lastplace         # open files at last edit
        indentLine            # visible indents
        auto-pairs            # closes brackets
        vim-fugitive          # use :g for Git commands
        vim-gitgutter         # indicates changes from current git branch
        vim-better-whitespace # makes trailing spaces visible
        vim-airline           # status bar at bottom of vim
        gruvbox               # colour scheme
      ];
      extraConfig = ''
        " Enable filetype plugins
        filetype plugin on
        filetype indent on

        " Remove inane defaults
        set backspace=indent,eol,start

        " Set tab behaviour
	set expandtab
        set autoindent
        set shiftwidth=2
        set tabstop=2

        " Remove error cues
        set noerrorbells
        set novisualbell

        " Enable pasting
	      set mouse=a

        " Visual cues
        syntax on
        set wrap " Wrap lines
        set number " Line numbers
        let g:indent_guides_enable_on_vim_startup = 1 " Indent guide plugin enable

        " Colour Scheme
        set background=dark
        colorscheme gruvbox

        " Escalate write if opened w/o sudo
        cmap w!! w !sudo tee % > /dev/null %
      '';

    };
    programs.bash = {
      enable = true;
      historyControl = [ "erasedups" ];
      initExtra = ''
        PS1="\n\[\e[1;32m\]\w\[\e[m\]\[\e[32m\] > \[\e[m\]"
      '';
      shellAliases = {
        la = "ls -a";
        l = "ls";
        c = "clear";
        grep = "grep --color=always";
        pull = "git pull";
        add = "git add";
        commit = "git commit -m";
        push = "git push";
        status = "git status";
        ".." = "cd ..";
      };
    };
    home.stateVersion = "23.11";
  };
  programs.chromium = {
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
    };
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "alistair";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Packages installed in system profile. To search, run: nix search wget
  environment.systemPackages = with pkgs; [
     vim
     cifs-utils
     gnome.gnome-tweaks
     # python38
     python312
     R
  ];

  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
