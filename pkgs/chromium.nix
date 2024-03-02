{ config, ... }:
{
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
        "AutofillAddressEnabled" = false;
    };
  };
}