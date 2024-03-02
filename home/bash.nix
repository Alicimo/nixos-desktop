{ config, pkgs, lib, ... }:
{
  home-manager.users.alistair = {
    programs.bash = {
      enable = true;
      historyControl = [ "erasedups" ];
      initExtra = ''
        PS1="\n\[\e[1;32m\]\w\[\e[m\]\[\e[32m\] > \[\e[m\]"
      '';
      shellAliases = {
        la = "ls -a";
        l = "ls";
        c = "clear";
        grep = "grep --color=always";
        pull = "git pull";
        add = "git add";
        commit = "git commit -m";
        push = "git push";
        status = "git status";
        ".." = "cd ..";
      };
    };
  };
}