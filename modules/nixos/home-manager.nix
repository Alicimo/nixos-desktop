let
  name = "Alistair Tiefenbacher";
  user = "alistair";
  email = "contact@alistair-martin.com";
in
{
  imports = [
    ./gnome.nix
    ./guake.nix
  ];

  home = {
    enableNixpkgsReleaseCheck = false;
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ./packages.nix {};
    stateVersion = "21.05";

    # The vscode config be editable
    activation =
    let
      configPath = "/home/alistair/.config/Code/User/settings.json";
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

  programs = import ../shared/home-manager.nix { inherit config pkgs lib; } // {
    git = {
      userName = name;
      userEmail = email;
    };
    thunderbird.enable = true;
    firefox.enable  = true;
  };
}