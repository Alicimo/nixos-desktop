{ pkgs, system }:

with pkgs;
let
  base = import ./packages.nix { inherit pkgs; };

  darwinPackages = [
    hblock # DNS adblocker for improved privacy and security
    google-cloud-sdk # CLI tools for Google Cloud Platform
    mas # Mac App Store command-line interface
    jira-cli-go # CLI tools to interact with JIRA
  ];

  nixosPackages = [
    # CLI utilities (included in MacOS)
    killall # Kill processes by name
    unzip # Extracts .zip archive files
    curl # Tool for transferring data with URLs
    zip # Package and compress files into .zip format

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
