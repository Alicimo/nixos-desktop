{ config, pkgs, lib, ... }:

let
    name = "Alistair Tiefenbacher";
    user = "tiefenbacher";
    email = "tiefenbacher@xund.ai";
in {

  atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      update_check = false;
    };
  };

  direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

  zsh = {
    enable = true;
    shellAliases = {
      ls = "ls -l";
      la = "ls -a";
      l = "ls";
      ll = "ls";
      c = "clear";
      pull = "git pull";
      add = "git add";
      commit = "git commit -m";
      push = "git push";
      status = "git status";
      ".." = "cd ..";
      cat = "bat";
      top = "btop";
      grep = "rg";
    };
    localVariables = {
      POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD = true;
    };
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    zplug = {
      enable = true;
      plugins = [
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
      ];
    };
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    userName = name;
    userEmail = email;
    lfs.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3";
      push.default = "current";
      diff.algorithm = "histogram";
    };
  };

  vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-lastplace         # open files at last edit
      indentLine            # visible indents
      auto-pairs            # closes brackets
      vim-gitgutter         # indicates changes from current git branch
      vim-better-whitespace # makes trailing spaces visible
      vim-airline           # status bar at bottom of vim
      gruvbox               # colour scheme
      nerdtree              # file browser
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

  ssh = {
    enable = true;
    serverAliveCountMax = 15;
    serverAliveInterval = 120;

    includes = [
      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux
        "/home/${user}/.ssh/config_external"
      )
      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
        "/Users/${user}/.ssh/config_external"
      )
    ];
  };

  vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      pkief.material-icon-theme
      pkief.material-product-icons

      # mechatroner.rainbow-csv
      # grapecity.gc-excelviewer
      # ms-toolsai.datawrangler
      streetsidesoftware.code-spell-checker
      christian-kohler.path-intellisense
      ms-vscode-remote.remote-ssh

      jnoortheen.nix-ide
      mikestead.dotenv
      ms-azuretools.vscode-docker

      ms-python.python
      ms-python.vscode-pylance
      charliermarsh.ruff

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
        name = "datawrangler";
        publisher = "ms-toolsai";
        version = "0.29.6";
        sha256 = "sha256-9MR2+hb9YdjIGDfUkdLW41HOxhjeS/San49C8QRZ/YY=";
      }
    ];
    userSettings = {
      "update.mode" = "none";

      "editor.fontFamily" = "Fira Code";
      "editor.fontLigatures" = true;
      "editor.minimap.enabled" = false;
      "editor.overviewRulerBorder" = false;
      "editor.bracketPairColorization.independentColorPoolPerBracketType" = true;

      "files.trimTrailingWhitespace" = true;
      "files.autoSave" = "afterDelay";

      "workbench.colorTheme" = "One Monokai";
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.productIconTheme" = "material-product-icons";

      "window.titleBarStyle" = "custom";
      "interactiveWindow.executeWithShiftEnter" = true;

      "[python]" = {
        "editor.defaultFormatter" = "charliermarsh.ruff";
        "editor.formatOnSave" = true;
        "editor.codeActionsOnSave" = {
          "source.fixAll" = "explicit";
          "source.organizeImports" = "explicit";
        };
      };

      "terminal.integrated.cwd" =  "\${workspaceFolder}";
      "jupyter.notebookFileRoot" = "\${workspaceFolder}";

      "remote.SSH.defaultExtensions" = [
        "streetsidesoftware.code-spell-checker"
        "christian-kohler.path-intellisense"
        "mikestead.dotenv"
        "ms-python.python"
        "ms-python.vscode-pylance"
        "charliermarsh.ruff"

        "ms-toolsai.jupyter"
        "ms-toolsai.vscode-jupyter-slideshow"
        "ms-toolsai.vscode-jupyter-cell-tags"
        "ms-toolsai.jupyter-renderers"
        "ms-toolsai.jupyter-keymap"
        "ms-toolsai.datawrangler"
      ];
    };

  };
}