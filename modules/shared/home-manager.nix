{ config, pkgs, lib, ... }:
{
  home-manager.enable = true;

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

  fish = {
    enable = true;
    shellAliases = {
      ls = "eza -l";
      l = "ls";
      ll = "ls";
      c = "clear";
      ".." = "cd ..";
      cat = "bat";
      top = "btop";
      grep = "rg";
      diff = "difft";
      du = "dust";
    };
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      { name = "bobthefish"; src = pkgs.fishPlugins.bobthefish.src; }
    ];
  };

  git = {
    enable = true;  # Enables Git support in the system configuration.

    ignores = [      # Specifies global Git ignore patterns.
      "*.swp"        # Ignore Vim swap files.
      ".DS_Store"    # Ignore macOS Finder metadata files.
      ".vscode"      # Ignore VS Code project settings.
      "__pycache__/" # Ignore Python bytecode cache directories.
      "venv/"        # Ignore Python virtual environment directories.
      ".env"         # Ignore environment files (e.g., containing secrets).
    ];

    lfs.enable = true;  # Enables Git Large File Storage (LFS) for handling large files efficiently.
    difftastic.enable = true;  # Enables Difftastic, a syntax-aware diff tool.

    extraConfig = {  # Additional Git configuration settings.
      init.defaultBranch = "main";  # Sets "main" as the default branch name instead of "master".
      merge.conflictstyle = "zdiff3";  # Uses "zdiff3" for merge conflicts, providing more context.
      push.default = "current";  # Pushes the current branch by default instead of requiring explicit naming.
      push.autoSetupRemote = true;  # Automatically sets up tracking branches when pushing for the first time.
      branch.sort = "committerdate";  # Sorts branches by the last commit date.
      rebase.autosquash = true;  # Automatically squashes fixup! and squash! commits during rebase.
      rebase.autostash = true;  # Stashes local changes before rebase and restores them afterward.
      rebase.updateRefs = true;  # Updates remote references when rebasing.
      column.ui = "auto";  # Enables column-based output formatting for certain Git commands when useful.
      fetch.prune = true;  # Automatically prunes deleted remote branches when fetching.
      fetch.all = true;  # Fetches updates from all remotes by default.
      help.autocorrect = "prompt";  # Suggests the closest matching command when a typo is detected.
      core.excludesfile = "~/.config/git/ignore";  # Specifies a custom global Git ignore file.
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
  };

  vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        pkief.material-icon-theme
        pkief.material-product-icons
        github.github-vscode-theme

        ms-toolsai.datawrangler
        streetsidesoftware.code-spell-checker
        christian-kohler.path-intellisense
        ms-vscode-remote.remote-ssh
        continue.continue

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
          name = "vsc-python-indent";
          publisher = "KevinRose";
          version = "1.18.1";
          sha256 = "sha256-etfQmVEtnTh/cVmjYfbi6sgCBSKUguh4TFMUy2ztRYk=";
        }
        {
          name = "dvc";
          publisher = "Iterative";
          version = "1.2.21";
          sha256 = "sha256-TBjN81+T9c/B8IjFlRqFwK43DYNBLGzNktdM1cwozbE=";
        }
      ];
      userSettings = {
        "update.mode" = "none";
        "extensions.ignoreRecommendations" = true;
        "continue.telemetryEnabled" = false;
        "cSpell.diagnosticLevel" = "Hint";

        "editor.fontFamily" = "Fira Code";
        "editor.fontLigatures" = true;
        "editor.minimap.enabled" = false;
        "editor.overviewRulerBorder" = false;
        "editor.bracketPairColorization.independentColorPoolPerBracketType" = true;
        "chat.commandCenter.enabled" = false;

        "files.trimTrailingWhitespace" = true;
        "files.autoSave" = "afterDelay";

        "window.autoDetectColorScheme" = true;
        "workbench.preferredDarkColorTheme" = "GitHub Dark";
        "workbench.preferredLightColorTheme" = "GitHub Light";
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
        "python.analysis.autoImportCompletions" = true;

        "terminal.integrated.cwd" =  "\${workspaceFolder}";
        "jupyter.notebookFileRoot" = "\${workspaceFolder}";

        "remote.SSH.defaultExtensions" = [
          "streetsidesoftware.code-spell-checker"
          "christian-kohler.path-intellisense"
          "mikestead.dotenv"
          "ms-python.python"
          "ms-python.vscode-pylance"
          "charliermarsh.ruff"
          "KevinRose.vsc-python-indent"

          "ms-toolsai.jupyter"
          "ms-toolsai.vscode-jupyter-slideshow"
          "ms-toolsai.vscode-jupyter-cell-tags"
          "ms-toolsai.jupyter-renderers"
          "ms-toolsai.jupyter-keymap"
          "ms-toolsai.datawrangler"
          "iterative.dvc"
        ];
      };
    };
  };
}
