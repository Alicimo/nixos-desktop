{ lib, ... }:

with lib;

{
  options.userConfig = {
    # Personal information
    name = mkOption {
      type = types.str;
      default = "Alistair Tiefenbacher";
      description = "Full name of the user";
    };

    email = {
      personal = mkOption {
        type = types.str;
        default = "contact@alistair-martin.com";
        description = "Personal email address";
      };

      work = mkOption {
        type = types.str;
        default = "tiefenbacher@xund.ai";
        description = "Work email address";
      };
    };

    # System-specific user configuration
    darwin = {
      username = mkOption {
        type = types.str;
        default = "tiefenbacher";
        description = "Username on Darwin systems";
      };

      homeDirectory = mkOption {
        type = types.str;
        default = "/Users/tiefenbacher";
        description = "Home directory path on Darwin systems";
      };

      hostname = mkOption {
        type = types.str;
        default = "tiefenbacher-macbook";
        description = "Hostname for Darwin system";
      };

      system = mkOption {
        type = types.str;
        default = "aarch64-darwin";
        description = "System architecture for Darwin";
      };
    };

    nixos = {
      username = mkOption {
        type = types.str;
        default = "alistair";
        description = "Username on NixOS systems";
      };

      homeDirectory = mkOption {
        type = types.str;
        default = "/home/alistair";
        description = "Home directory path on NixOS systems";
      };

      hostname = mkOption {
        type = types.str;
        default = "tiefenbacher-desktop";
        description = "Hostname for NixOS system";
      };

      system = mkOption {
        type = types.str;
        default = "x86_64-linux";
        description = "System architecture for NixOS";
      };
    };

    # Application-specific paths and configurations
    paths = {
      vscode = {
        darwin = mkOption {
          type = types.str;
          default = "/Users/tiefenbacher/Library/Application Support/Code/User/settings.json";
          description = "VS Code settings path on Darwin";
        };

        nixos = mkOption {
          type = types.str;
          default = "/home/alistair/.config/Code/User/settings.json";
          description = "VS Code settings path on NixOS";
        };
      };

      ssh = {
        darwin = mkOption {
          type = types.str;
          default = "/Users/tiefenbacher/.ssh/config_external";
          description = "External SSH config path on Darwin";
        };

        nixos = mkOption {
          type = types.str;
          default = "/home/alistair/.ssh/config_external";
          description = "External SSH config path on NixOS";
        };
      };
    };

    # Service configurations
    services = {
      homepage = {
        darwin = mkOption {
          type = types.str;
          default = "http://localhost:5000";
          description = "Homepage URL on Darwin";
        };

        nixos = mkOption {
          type = types.str;
          default = "http://tiefenbacher.home";
          description = "Homepage URL on NixOS";
        };
      };
    };

    # Git configuration
    git = {
      globalIgnorePath = mkOption {
        type = types.str;
        default = "~/.config/git/ignore";
        description = "Global git ignore file path (uniform across systems)";
      };
    };
  };

  config = {
    # Set default values - this allows the module to be imported without configuration
    userConfig = { };
  };
}
