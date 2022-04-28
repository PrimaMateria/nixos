#    Y88d      / 888      e    e      
#     Y88b    /  888     d8b  d8b     
#      Y88b  /   888    d888bdY88b    
#       Y888/    888   / Y88Y Y888b   
#        Y8/     888  /   YY   Y888b  
#         Y      888 /          Y888b 

{ pkgs, config, lib, ... }:
let
  plugin = { url, rev, sha256 }:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = with lib; (last (splitString "/" url));
      version = rev;
      src = pkgs.fetchgit { inherit url rev sha256; };
    };
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = false;
    withPython3 = true;
    withRuby = false;

    plugins = with pkgs.vimPlugins; [
      fern-vim
      goyo-vim
      gruvbox-community
      harpoon
      lightline-gruvbox-vim
      lightline-vim
      lush-nvim
      nvim-compe
      nvim-treesitter
      plenary-nvim
      popup-nvim
      tabular
      telescope-nvim
      telescope-project-nvim
      ultisnips
      vim-nix
      vim-sandwich

      # Git
      gv-vim
      vim-fugitive
      vim-gitgutter

      # Commenting
      vim-commentary
      nvim-ts-context-commentstring

      # Completition
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      #cmp-nvim-ultisnips

      nvim-lspconfig
      null-ls-nvim
      nvim-lsp-ts-utils
    ];

    extraConfig = ''
      syntax on
      filetype plugin indent on

      let mapleader = " "
      inoremap <C-j><C-j> <C-\><C-n>
      tnoremap <C-j><C-j> <C-\><C-n>
      nnoremap <leader><BS> :b#<CR>

      "-------------------------------------------------- 
      " Gruvbox community Color scheme
      "-------------------------------------------------- 
      let g:gruvbox_contrast_dark='hard'
      colorscheme gruvbox

      "-------------------------------------------------- 
      " \
      "-------------------------------------------------- 
      nnoremap \\ :w<cr>
      nnoremap \s :so %<cr>
      nnoremap \w :bw!<cr>
      nnoremap \g :Goyo<cr>
      nnoremap \i :PlugInstall<cr>
      nnoremap \c :PlugClean<cr>
      nnoremap \t :term<cr>
    ''
    + import ./nvim-compe.nix
    + import ./nvim-fern.nix
    + import ./nvim-fugitive.nix
    + import ./nvim-harpoon.nix
    + import ./nvim-lightline.nix
    + import ./nvim-setters.nix
    + import ./nvim-telescope-project.nix
    + import ./nvim-telescope.nix
    + import ./nvim-treesitter.nix
    + import ./nvim-ultisnips.nix
    + import ./nvim-lspconfig-ts.nix
    + import ./nvim-lspconfig-null-ls.nix
    ;
  };

  home.packages = with pkgs; [
    ripgrep
    # Plus reg sync to system clipboard, see https://neovim.io/doc/user/provider.html#clipboard-tool
    xsel 
    nodejs_latest
    nodePackages.typescript-language-server
    nodePackages.eslint_d
    # TODO: need to get prettier_slim_d
  ];
}
