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

    /*
      Not migrated plugins:
      Unused/Not wanted anymore:
        Plug 'christoomey/vim-tmux-navigator' 
        Plug 'glepnir/lspsaga.nvim'
        Plug 'mattn/emmet-vim'
        Plug 'mboughaba/i3config.vim'
        Plug 'rust-lang/rust.vim'
        Plug 'sainnhe/sonokai'
        Plug 'simrat39/symbols-outline.nvim'
        Plug 'stevearc/vim-arduino'
        Plug 'theprimeagen/vim-be-good'
        Plug 'tpope/vim-projectionist'
        Plug 'tpope/vim-scriptease'
      Left as todo:
        Plug 'jose-elias-alvarez/null-ls.nvim'
        Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
      Don't know how:
        Plug 'kabouzeid/nvim-lspinstall'
    */

    plugins = with pkgs.vimPlugins; [
      fern-vim
      goyo-vim
      gruvbox-community
      gv-vim
      harpoon
      lightline-gruvbox-vim
      lightline-vim
      lush-nvim
      nerdcommenter
      nvim-compe
      nvim-treesitter
      plenary-nvim
      popup-nvim
      tabular
      telescope-nvim
      telescope-project-nvim
      ultisnips
      vim-fugitive
      vim-nix
      vim-sandwich
      vim-signify
    ];

    extraConfig = ''
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
      " Lightline
      "-------------------------------------------------- 
      " seoul256
      let g:lightline = {
        \ 'colorscheme': 'gruvbox',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'readonly', 'filename', 'modified' ]
        \           ],
        \   'right': [ [ 'lineinfo' ],
        \              [ 'percent' ],
        \              [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ] ]
        \ },
        \ 'component_function': {
        \   'gitbranch': 'FugitiveHead'
        \ },
        \ }

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

      "-------------------------------------------------- 
      " Telescope
      "-------------------------------------------------- 
      lua <<EOF
      local opt = { noremap = true }

      vim.api.nvim_set_keymap("n", "<leader><leader>", ":lua require('telescope.builtin').find_files()<CR>", opt);
      vim.api.nvim_set_keymap("n", "<leader><tab>", ":lua require('telescope.builtin').buffers()<CR>", opt);
      vim.api.nvim_set_keymap("n", "<leader>`", ":lua require('telescope.builtin').live_grep()<CR>", opt);
      vim.api.nvim_set_keymap("n", "<leader>~", ":lua require('telescope.builtin').grep_string()<CR>", opt);

      -- Git
      vim.api.nvim_set_keymap("n", "<leader>gb", ":lua require('telescope.builtin').git_branches()<cr>", opt);
      vim.api.nvim_set_keymap("n", "<leader>gs", ":lua require('telescope.builtin').git_status()<cr>", opt);
      --vim.api.nvim_set_keymap("n", "<leader>gc", ":lua require('telescope.builtin').git_commits()<cr>", opt);
      --vim.api.nvim_set_keymap("n", "<leader>gf", ":lua require('telescope.builtin').git_bcommits()<cr>", opt);

      -- LSP
      vim.api.nvim_set_keymap("n", ",aa", ":lua require('telescope.builtin').lsp_code_actions()<cr>", opt);
      vim.api.nvim_set_keymap("n", ",d", ":lua require('telescope.builtin').lsp_document_diagnostics()<cr>", opt);
      vim.api.nvim_set_keymap("n", "gr", ":lua require('telescope.builtin').lsp_references()<cr>", opt);
      vim.api.nvim_set_keymap("n", "gd", ":lua require('telescope.builtin').lsp_definitions()<cr>", opt);
      --vim.api.nvim_set_keymap("n", "go", ":lua require('telescope.builtin').lsp_document_symbols()<cr>", opt);
      EOF

      "-------------------------------------------------- 
      " Fugitive
      "-------------------------------------------------- 
      nnoremap <leader>gg :topleft vertical Git<cr>
      nnoremap <leader>gmh :diffget //2<cr>
      nnoremap <leader>gml :diffget //3<cr>
      "nnoremap <leader>gl :vnew<cr>:terminal watch --color git lgb HEAD develop<cr>
      " GV
      nnoremap <leader>gl :GV<cr>
      nnoremap <leader>gf :GV!<cr>

      "-------------------------------------------------- 
      " UltiSnips
      "-------------------------------------------------- 
      let g:UltiSnipsExpandTrigger="<tab>"
      let g:UltiSnipsJumpForwardTrigger="<c-j>"
      let g:UltiSnipsJumpBackwardTrigger="<c-k>"
      let g:UltiSnipsEditSplit="vertical"

      augroup ultisnips
        au!
        autocmd FileType javascript,javascriptreact,typescript,typescriptreact
          \ UltiSnipsAddFiletypes javascript.javascriptreact.typescript.typescriptreact
      augroup END

      "-------------------------------------------------- 
      " Fern
      "-------------------------------------------------- 
      nnoremap <C-n> :Fern . -drawer -toggle<CR>
      function! s:init_fern() abort
      endfunction

      augroup fern-custom
        autocmd! *
        autocmd FileType fern call s:init_fern()
      augroup END

      "-------------------------------------------------- 
      " Treesitter
      "-------------------------------------------------- 
      lua <<EOF
      require'nvim-treesitter.configs'.setup {
        highlight = {
          enable = true,
        },
      }
      EOF

      "-------------------------------------------------- 
      " Compe
      "-------------------------------------------------- 
      lua << EOF
      vim.o.completeopt = "menuone,noselect"
      require('compe').setup {
        enabled = true;
        autocomplete = true;
        debug = true;
        min_length = 1;
        preselect = 'enable';
        throttle_time = 80;
        source_timeout = 200;
        incomplete_delay = 400;
        max_abbr_width = 100;
        max_kind_width = 100;
        max_menu_width = 100;
        documentation = true;
        source = {
          nvim_lsp = true;
          path = true;
          buffer = false;
          calc = true;
          nvim_lua = true;
          vsnip = true;
          ultisnips = true;
        };
      }
      --This line is important for auto-import
      vim.api.nvim_set_keymap('i', '<cr>', 'compe#confirm("<cr>")', { expr = true })
      EOF

      "-------------------------------------------------- 
      " Telescope Project
      "-------------------------------------------------- 
      lua << EOF
      require('telescope').load_extension('project')
      vim.api.nvim_set_keymap(
          'n',
          '<C-p>',
          ":lua require'telescope'.extensions.project.project{}<CR>",
          {noremap = true, silent = true}
      )
      EOF

      "-------------------------------------------------- 
      " Harpoon
      "-------------------------------------------------- 
      lua << EOF
      require"harpoon".setup()

      local opt = { noremap = true }
      vim.api.nvim_set_keymap("n", "<leader>tt", ":lua require('harpoon.term').gotoTerminal(1)<CR>", opt);
      vim.api.nvim_set_keymap("n", "<leader>tq", ":lua require('harpoon.term').gotoTerminal(2)<CR>", opt);
      vim.api.nvim_set_keymap("n", "<leader>tw", ":lua require('harpoon.term').gotoTerminal(3)<CR>", opt);
      vim.api.nvim_set_keymap("n", "<leader>te", ":lua require('harpoon.term').gotoTerminal(4)<CR>", opt);
      vim.api.nvim_set_keymap("n", "<leader>tr", ":lua require('harpoon.term').gotoTerminal(5)<CR>", opt);
      vim.api.nvim_set_keymap("n", "<leader>a", ":lua require('harpoon.mark').add_file()<CR>", opt);
      vim.api.nvim_set_keymap("n", "<leader>f", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", opt);
      vim.api.nvim_set_keymap("n", "<leader>q", ":lua require('harpoon.ui').nav_file(1)<CR>", opt);
      vim.api.nvim_set_keymap("n", "<leader>w", ":lua require('harpoon.ui').nav_file(2)<CR>", opt);
      vim.api.nvim_set_keymap("n", "<leader>e", ":lua require('harpoon.ui').nav_file(3)<CR>", opt);
      vim.api.nvim_set_keymap("n", "<leader>r", ":lua require('harpoon.ui').nav_file(4)<CR>", opt);
      EOF
    '';
  };

  #home.packages = with pkgs; [
  #];
}

