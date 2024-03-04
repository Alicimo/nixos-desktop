{ config, pkgs, lib, ... }:
{
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-lastplace         # open files at last edit
      indentLine            # visible indents
      auto-pairs            # closes brackets
      vim-fugitive          # use :g for Git commands
      vim-gitgutter         # indicates changes from current git branch
      vim-better-whitespace # makes trailing spaces visible
      vim-airline           # status bar at bottom of vim
      gruvbox               # colour scheme
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
}