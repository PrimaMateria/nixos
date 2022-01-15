
"           Y88d      / 888      e    e      
"            Y88b    /  888     d8b  d8b     
"             Y88b  /   888    d888bdY88b    
"              Y888/    888   / Y88Y Y888b   
"               Y8/     888  /   YY   Y888b  
"                Y      888 /          Y888b 
                       
syntax on
filetype plugin indent on

set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set number
set exrc
set secure
set termguicolors
set nohlsearch
set hidden
set guicursor=
set scrolloff=0
set signcolumn=yes
set colorcolumn=80
set undodir=~/.config/nvim/undodir
set undofile
set incsearch
set updatetime=50
set cursorline
set cursorcolumn
set splitbelow
set splitright
set relativenumber
set sessionoptions+=tabpages,globals
set ignorecase
set shell=bash\ -l

call plug#begin('~/.config/nvim/plugged')
  Plug 'SirVer/ultisnips'
  Plug 'ThePrimeagen/harpoon'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'glepnir/lspsaga.nvim'
  Plug 'godlygeek/tabular'
  Plug 'gruvbox-community/gruvbox'
  Plug 'hrsh7th/nvim-compe'
  Plug 'itchyny/lightline.vim'
  Plug 'jose-elias-alvarez/null-ls.nvim'
  Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
  Plug 'junegunn/goyo.vim'
  Plug 'junegunn/gv.vim'
  Plug 'kabouzeid/nvim-lspinstall'
  Plug 'lambdalisue/fern.vim'
  Plug 'machakann/vim-sandwich'
  Plug 'mattn/emmet-vim'
  Plug 'mboughaba/i3config.vim'
  Plug 'mhinz/vim-signify'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-telescope/telescope-project.nvim'
  Plug 'nvim-telescope/telescope.nvim', { 'tag': 'nvim-0.5.1' }
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'rktjmp/lush.nvim'
  Plug 'rust-lang/rust.vim'
  Plug 'sainnhe/sonokai'
  Plug 'scrooloose/nerdcommenter'
  Plug 'simrat39/symbols-outline.nvim'
  Plug 'stevearc/vim-arduino'
  Plug 'theprimeagen/vim-be-good'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-projectionist'
  Plug 'tpope/vim-scriptease'
call plug#end()
