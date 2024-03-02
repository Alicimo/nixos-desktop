{ config, pkgs, lib, ... }:
{
  home-manager.users.alistair = {
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
  };
}