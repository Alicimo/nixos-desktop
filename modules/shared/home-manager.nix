{
  config,
  pkgs,
  lib,
  platform ? null,
  ...
}:

let
  userCfg = config.userConfig;

  # VS Code activation script for making config writable
  mkVSCodeActivation =
    platform:
    let
      configPath = userCfg.paths.vscode.${platform};
    in
    {
      beforeCheckLinkTargets = {
        after = [ ];
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

in
{
  home-manager.enable = true;

  atuin = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = false;
    flags = [ "--disable-up-arrow" ];
    settings = {
      update_check = false;
    };
  };

  direnv = {
    enable = true;
    enableZshIntegration = false;
    nix-direnv.enable = true;
  };

  ghostty = {
    enable = true;
    enableZshIntegration = false;
    package = if platform == "darwin" then null else pkgs.ghostty; # Use cask on macOS, package on Linux
    settings = {
      theme = "Github Light Default";
      font-family = "Fira Code";
      keybind = [
        "global:§=toggle_quick_terminal"
        "shift+enter=text:\n"
      ];
    };
  };

  fish = {
    enable = true;
    shellAliases = {
      ls = "eza -l";
      l = "ls";
      ll = "ls";
      c = "clear";
      "cd.." = "cd ..";
      ".." = "cd ..";
      cat = "bat";
      top = "btop";
      grep = "rg";
      diff = "difft";
      du = "dust";
      today = "date +%Y-%m-%d";
      llm = "codex exec --skip-git-repo-check";
    };
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    functions = {
      mkcd = ''
        mkdir -p $argv[1]
        cd $argv[1]
      '';
    };
    plugins = [
      {
        name = "bobthefish";
        src = pkgs.fishPlugins.bobthefish.src;
      }
    ];
    shellInit = ''
      codex completion fish | source
    '';
  };

  git = {
    enable = true; # Enables Git support in the system configuration.

    ignores = [
      # Specifies global Git ignore patterns.
      "*.swp" # Ignore Vim swap files.
      ".DS_Store" # Ignore macOS Finder metadata files.
      ".vscode" # Ignore VS Code project settings.
      "__pycache__/" # Ignore Python bytecode cache directories.
      "venv/" # Ignore Python virtual environment directories.
      ".env" # Ignore environment files (e.g., containing secrets).
      ".claude/" # Ignore Claude Code session files.
      "CLAUDE.md" # Ignore Claude Code project documentation.
      "AGENTS.md" # Ignore Agent Code project documentation.
      ".aider*" # Ignore Aider AI coding assistant files.
      "prompts/" # Ignore prompts directory.
    ];

    lfs.enable = true; # Enables Git Large File Storage (LFS) for handling large files efficiently.

    settings = {
      # Core Git configuration
      core.excludesfile = "~/.config/git/ignore"; # Points to the global gitignore file created by ignores option.
      init.defaultBranch = "main"; # Sets "main" as the default branch name instead of "master".

      # Remote operations
      push = {
        default = "current"; # Pushes the current branch by default instead of requiring explicit naming.
        autoSetupRemote = true; # Automatically sets up tracking branches when pushing for the first time.
      };
      fetch = {
        prune = true; # Automatically prunes deleted remote branches when fetching.
        all = true; # Fetches updates from all remotes by default.
      };

      # Branch and merge operations
      branch.sort = "committerdate"; # Sorts branches by the last commit date.
      merge.conflictstyle = "zdiff3"; # Uses "zdiff3" for merge conflicts, providing more context.

      # Rebase operations
      rebase = {
        autosquash = true; # Automatically squashes fixup! and squash! commits during rebase.
        autostash = true; # Stashes local changes before rebase and restores them afterward.
        updateRefs = true; # Updates remote references when rebasing.
      };

      # UI and help
      column.ui = "auto"; # Enables column-based output formatting for certain Git commands when useful.
      help.autocorrect = "prompt"; # Suggests the closest matching command when a typo is detected.
    };
  };

  # Difftastic, a syntax-aware diff tool.
  difftastic = {
    enable = true;
    git.enable = true;
  };

  vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-lastplace # open files at last edit
      indentLine # visible indents
      auto-pairs # closes brackets
      vim-gitgutter # indicates changes from current git branch
      vim-better-whitespace # makes trailing spaces visible
      vim-airline # status bar at bottom of vim
      gruvbox # colour scheme
      nerdtree # file browser
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
    enableDefaultConfig = false;
    matchBlocks."*" = {
      serverAliveCountMax = 15;
      serverAliveInterval = 120;
    };
  };

  vscode = {
    enable = true;
    profiles.default = {
      extensions =
        with pkgs.vscode-extensions;
        [
          pkief.material-icon-theme
          pkief.material-product-icons
          github.github-vscode-theme

          gitlab.gitlab-workflow
          ms-toolsai.datawrangler
          mechatroner.rainbow-csv
          streetsidesoftware.code-spell-checker
          christian-kohler.path-intellisense
          ms-vscode-remote.remote-ssh

          mikestead.dotenv
          ms-azuretools.vscode-docker
          bbenoist.nix

          ms-python.python
          ms-python.vscode-pylance
          charliermarsh.ruff

          ms-toolsai.jupyter
          ms-toolsai.vscode-jupyter-slideshow
          ms-toolsai.vscode-jupyter-cell-tags
          ms-toolsai.jupyter-renderers
          ms-toolsai.jupyter-keymap

        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "vsc-python-indent";
            publisher = "KevinRose";
            version = "1.21.0";
            sha256 = "sha256-etfQmVEtnTh/cVmjYfbi6sgCBSKUguh4TFMUy2ztRYk=";
          }
        ];
      userSettings = {
        "update.mode" = "none";
        "extensions.ignoreRecommendations" = true;
        "cSpell.diagnosticLevel" = "Hint";

        "gitlab.duoChat.enabled" = false;
        "gitlab.duoAgentPlatform.enabled" = false;

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

        "terminal.integrated.cwd" = "\${workspaceFolder}";
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
        ];
      };
    };
  };

  # Firefox configuration - shared across platforms
  # Extensions to add post-install
  # - 1Password / Bitwarden
  # - UBlockOrigin
  # - Sponsorblock
  # - LocalCDN
  firefox = lib.mkIf (platform != null) {
    enable = true;
    profiles."default" = {
      id = 0;
      isDefault = true;
      settings = {
        "browser.startup.homepage" = userCfg.services.homepage.${platform};
        "extensions.pocket.enabled" = false;
        "signon.rememberSignons" = false;
        "browser.newtabpage.enabled" = false;
        "browser.vpn_promo.enabled" = false;
        "identity.fxaccounts.enabled" = false;
        "intl.locale.requested" = "en-GB";
        "browser.ml.enable" = false;

        # Telementry
        "toolkit.telemetry.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.sessions.current.clean" = true;
        "datareporting.sessions.current.activeTicks" = 0;
        "datareporting.healthreport.service.enabled" = false;
        "app.normandy.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        "browser.tabs.crashReporting.sendReports" = false;
        "browser.urlbar.suggest.searches" = false;

        # Sidebar and vertical tabs settings
        "sidebar.expandOnHoverMessage.dismissed" = true;
        "sidebar.new-sidebar.has-used" = true;
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
        "sidebar.main.tools" = "history,bookmarks";
        "sidebar.visibility" = "always-show";

      };
      search = {
        default = "google";
        force = true;
        engines = {
          "Nix Packages" = {
            definedAliases = [ "@np" ];
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          };
          "Nix Options" = {
            definedAliases = [ "@no" ];
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };
          "ChatGPT" = {
            definedAliases = [ "@gpt" ];
            urls = [
              {
                template = "https://chatgpt.com/";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };
          "Perplexity" = {
            definedAliases = [ "@p" ];
            urls = [
              {
                template = "https://www.perplexity.ai/";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
          };
          "google".metaData.alias = "@g";
        };
      };
    };
  };
}
