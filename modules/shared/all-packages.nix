{ pkgs, system }:

with pkgs;
let
  base = import ./packages.nix { inherit pkgs; };

  feishin-bin = stdenvNoCC.mkDerivation rec {
    pname = "feishin";
    version = "1.14.0";

    src = fetchurl {
      url = "https://github.com/jeffvli/feishin/releases/download/v${version}/Feishin-${version}-mac-arm64.dmg";
      hash = "sha256-wOJw55oZjYhIr5KgAcrXttCOC2g3A7v2Tj2YHiKiZUk=";
    };

    nativeBuildInputs = [ undmg ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications"
      cp -R Feishin.app "$out/Applications/"

      runHook postInstall
    '';
  };

  darwinPackages = [
    hblock # DNS adblocker for improved privacy and security
    mas # Mac App Store command-line interface
    jira-cli-go # CLI tools to interact with JIRA
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.kubectl])
    feishin-bin # Music player
    stable.R # Language and environment for statistical computing
    stable.quarto # Wrapper for pandoc
    stable.visidata # Terminal spreadsheet multitool for data exploration
  ];

  nixosPackages = [
    # CLI utilities (included in MacOS)
    killall # Kill processes by name
    unzip # Extracts .zip archive files
    curl # Tool for transferring data with URLs
    zip # Package and compress files into .zip format

    # Dev
    R # Language and environment for statistical computing
    quarto # Wrapper for pandoc
    visidata # Terminal spreadsheet multitool for data exploration

    # Desktop applications
    mpv # Media player for audio and video files
    libreoffice # Office suite with word processor, spreadsheet, and presentation software
    anki # Spaced repetition flashcard program for learning
    telegram-desktop # Desktop client for Telegram messaging
    thunderbird # Email client with calendar and contacts
    chromium # Open-source web browser

    # Entertainment
    spotube # Spotify client using YouTube as audio source
    freetube # Privacy-focused YouTube client
    steam # Gaming platform and digital distribution service

    # Media processing
    handbrake # Video transcoder for converting between formats
    makemkv # DVD and Blu-ray disc ripper
    abcde # CD ripper and encoder
    flac # Free lossless audio codec tools

    # System utilities
    brlaser # Brother laser printer driver
    borgbackup # Deduplicating backup program
  ];

in
if system == "x86_64-linux" then
  base ++ nixosPackages
else if system == "aarch64-darwin" then
  base ++ darwinPackages
else
  base
