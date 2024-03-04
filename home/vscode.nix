{ config, pkgs, lib, ... }:
{
  # The below lets vscode setting.json be editable
  # home.activation = {
  #   boforeCheckLinkTargets = {
  #     after = [];
  #     before = [ "checkLinkTargets" ];
  #     data = ''
  #       userDir=/home/alistair/.config/Code/User
  #       rm -rf $userDir/settings.json
  #     '';
  #   };
  #   afterWriteBoundary = {
  #     after = [ "writeBoundary" ];
  #     before = [];
  #     data = ''
  #       userDir=/home/alistair/.config/Code/User
  #       rm -rf $userDir/settings.json
  #       cat \
  #         ${(pkgs.formats.json {}).generate "blabla"
  #           config.home-manager.users.alistair.programs.vscode.userSettings} \
  #         > $userDir/settings.json
  #     '';
  #   };
  # };
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
      fira-code
      fira-code-symbols
  ];
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
      {
        name = "twinny";
        publisher = "rjmacarthy";
        version = "3.7.8";
        sha256 = "sha256-C+NfG3J4WpRJJorJnwSlaD2jtcJFmhKpE3C32DId36o=";
      }
    ];
    userSettings = {
      "update.mode" = "none";
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
      "twinny.apiProvider" = "llamacpp";
      "twinny.fimApiPath" = "/completion";
      "twinny.chatApiPath" = "/completion";
      "twinny.chatApiPort" = 8080;
      "twinny.fimApiPort" = 8080;
    };
  };
}