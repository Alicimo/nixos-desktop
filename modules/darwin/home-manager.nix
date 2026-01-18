{
  config,
  pkgs,
  lib,
  home-manager,
  ...
}:

let
  userCfg = config.userConfig;
  user = userCfg.darwin.username;
in
{
  users.users.${user} = {
    name = "${user}";
    home = userCfg.darwin.homeDirectory;
    isHidden = false;
    shell = pkgs.zsh;
  };

  programs.fish.enable = true;

  homebrew = {
    # This is a module from nix-darwin
    # Homebrew is *installed* via the flake input nix-homebrew
    enable = true;
    casks = pkgs.callPackage ./casks.nix { };
    brews = [
      "lightgbm" # for pycaret
    ];
    # masApps = { # Does not work
    #   "Spokenly" = 6740315592;
    # };
    global = {
      autoUpdate = true;
    };
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      let
        # Now userConfig is available via config.userConfig due to the import
        userCfg = config.userConfig;

        # VS Code activation function using userConfig
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

        # Import shared configuration with platform context
        shared-config = import ../shared/home-manager.nix {
          inherit config pkgs lib;
          platform = "darwin";
        };
      in
      {
        imports = [
          # Import the user-config module so userConfig is available
          ../shared/user-config.nix
        ];

        home = {
          enableNixpkgsReleaseCheck = false;
          packages = import ../shared/all-packages.nix {
            inherit pkgs;
            system = userCfg.darwin.system;
          };
          stateVersion = "23.11";

          sessionPath = [
            "$HOME/bin"
          ];
          file = {
            "bin/copy" = {
              source = ../../scripts/bin/copy.sh;
              executable = true;
            };
            "bin/pasta" = {
              source = ../../scripts/bin/pasta.sh;
              executable = true;
            };
            "bin/ds-destroy" = {
              source = ../../scripts/bin/ds-destroy.sh;
              executable = true;
            };
            "bin/wifi-toggle" = {
              source = ../../scripts/bin/wifi-toggle.sh;
              executable = true;
            };
            ".codex/prompts/python-checkup.md" = {
              text = ''
                ---
                description: Run formatting, linting, and testing checks for a Python project
                ---

                1. Execute the following checks in order:

                   * `uv run ruff format .` –  Code formating using Ruff
                   * `uv run ruff check .` – Static analysis and linting using Ruff
                   * `uv run pytest` –  Test suite with `pytest`

                2. If **any command fails**:

                   * Applies necessary changes (e.g., formatting)
                   * Reruns the affected check(s)
                   * If an earlier step (e.g., linting or formatting) passed **before**, it’s rerun to ensure consistency

                3. Repeats this cycle until:

                   * All three checks pass without any errors or fixes
                   * The code is clean, styled, and test-verified
              '';
            };
            ".codex/prompts/RTFM.md" = {
              text = ''
                ---
                description: Reads all documentation in a Git repo
                ---

                1. Recursively search the Git repository for all .md (Markdown) files
                2. Ignore standard build and dependency folders (e.g. node_modules, dist, build)
                3. Read each file's content
              '';
            };
            ".codex/prompts/commit.md" = {
              text = ''
                ---
                description: Write a concise, clear, and descriptive Git commit message
                ---

                1. Checks which files are staged with `git status`
                2. If 0 files are staged, automatically adds all modified and new files with `git add`
                3. Performs a `git diff` to understand what changes are being committed
                4. Analyzes the diff to determine if multiple distinct logical changes are present
                5. If multiple distinct changes are detected, suggests breaking the commit into multiple smaller commits
                6. For each commit (or the single commit if not split), creates a commit message using emoji conventional commit format

                ## Best Practices for Commits

                - **Atomic commits**: Each commit should contain related changes that serve a single purpose
                - **Split large changes**: If changes touch multiple concerns, split them into separate commits
                - **Conventional commit format**: Use the format `<type>: <description>` where type is one of:
                  - `feat`: A new feature
                  - `fix`: A bug fix
                  - `docs`: Documentation changes
                  - `style`: Code style changes (formatting, etc)
                  - `refactor`: Code changes that neither fix bugs nor add features
                  - `perf`: Performance improvements
                  - `test`: Adding or fixing tests
                  - `chore`: Changes to the build process, tools, etc.
                - **Present tense, imperative mood**: Write commit messages as commands (e.g., "add feature" not "added feature")

                ## Guidelines for Splitting Commits

                When analyzing the diff, consider splitting commits based on these criteria:

                1. **Different concerns**: Changes to unrelated parts of the codebase
                2. **Different types of changes**: Mixing features, fixes, refactoring, etc.
                3. **File patterns**: Changes to different types of files (e.g., source code vs documentation)
                4. **Logical grouping**: Changes that would be easier to understand or review separately
                5. **Size**: Very large changes that would be clearer if broken down

                ## Examples

                Good commit messages:
                - feat: add user authentication system
                - fix: resolve memory leak in rendering process
                - docs: update API documentation with new endpoints
                - refactor: simplify error handling logic in parser
              '';
            };
            ".hushlogin".text = "";
          };

          # VS Code activation using shared function
          activation = mkVSCodeActivation "darwin";
        };

        # Define a LaunchAgent to run hblock periodically
        launchd.agents.hblock = {
          enable = true;
          config = {
            Program = "${pkgs.hblock}/bin/hblock";
            StartInterval = 86400; # Run once per day
            StandardOutPath = "${userCfg.darwin.homeDirectory}/Library/Logs/hblock.log";
            StandardErrorPath = "${userCfg.darwin.homeDirectory}/Library/Logs/hblock-error.log";
          };
        };

        programs = shared-config // {
          ssh = shared-config.ssh // {
            includes = [ userCfg.paths.ssh.darwin ];
          };
          zsh = {
            enable = true;
            initContent = ''
              if [[ $(ps -o command= -p "$PPID" | awk '{print $1}') != 'fish' ]]
              then
                  exec fish -l
              fi
            '';
          };
        };
      };
  };
}
