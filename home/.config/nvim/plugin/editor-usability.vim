let mapleader = " "
nnoremap <leader><BS> :b#<CR>
nnoremap <C-t> :TagbarToggle<CR>
"write
nnoremap \\ :w<cr>
"source current file
nnoremap \s :so %<cr>
"wipe out all buffers
nnoremap \W :wa<cr>:bufdo bw!<cr>
"wipe buffer
nnoremap \w :bw!<cr>
"some new way of escaping mode
inoremap <C-j><C-j> <C-\><C-n>
"center buffer with goyo
nnoremap \g :Goyo<cr>
nnoremap \i :PlugInstall<cr>
nnoremap \c :PlugClean<cr>
nnoremap \t :term<cr>

augroup primamateria-usability
  autocmd!
  " Don't add comment sign on new line automatically
  autocmd BufNewFile,BufRead * setlocal formatoptions-=cro
  autocmd FileType help wincmd L
augroup END

"-------------------------------------------------- 
" Tabs
"-------------------------------------------------- 
nnoremap <A-j> :tabprevious<cr>
nnoremap <A-k> :tabnext<cr>
nnoremap <A-1> :tabnext1<cr>
nnoremap <A-2> :tabnext2<cr>
nnoremap <A-3> :tabnext3<cr>
nnoremap <A-4> :tabnext4<cr>
nnoremap <A-5> :tabnext5<cr>
nnoremap <A-6> :tabnext6<cr>
nnoremap <A-7> :tabnext7<cr>
nnoremap <A-8> :tabnext8<cr>
nnoremap <A-9> :tabnext9<cr>

"-------------------------------------------------- 
" Terminal
"-------------------------------------------------- 
" escape terminal mode as usual
tnoremap <C-j><C-j> <C-\><C-n>

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

inoremap <c-g><c-g> <esc>:.!jiratag<cr>A

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
" LSP
"-------------------------------------------------- 
lua << EOF
local common_on_attach = function(client, bufnr)
end

-- enable null-ls integration (optional)
require("null-ls").config {}
require("lspconfig")["null-ls"].setup {}

local nvim_lsp = require('lspconfig')
nvim_lsp.tsserver.setup {
  on_attach = function(client, buffnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    --Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- disable tsserver formatting if you plan on formatting via null-ls
    client.resolved_capabilities.document_formatting = false
    -- define an alias
    vim.cmd("command -buffer Formatting lua vim.lsp.buf.formatting()")
    vim.cmd("command -buffer FormattingSync lua vim.lsp.buf.formatting_sync()")
    -- format on save
    vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")

    local ts_utils = require("nvim-lsp-ts-utils")
    -- defaults
    ts_utils.setup {
        debug = false,
        disable_commands = false,
        enable_import_on_completion = true,

        -- import all
        import_all_timeout = 5000, -- ms
        import_all_priorities = {
            buffers = 4, -- loaded buffer names
            buffer_content = 3, -- loaded buffer content
            local_files = 2, -- git files or files with relative path markers
            same_file = 1, -- add to existing import statement
        },
        import_all_scan_buffers = 100,
        import_all_select_source = false,

        -- eslint
        eslint_enable_code_actions = true,
        eslint_enable_disable_comments = true,
        eslint_bin = "eslint_d",
        --eslint_config_fallback = ".eslintrc",
        eslint_enable_diagnostics = true,
        eslint_show_rule_id = false,

        -- formatting
        enable_formatting = true,
        formatter = "prettier",
        --formatter_config_fallback = ".prerttierc",

        -- update imports on file move
        update_imports_on_move = false,
        require_confirmation_on_move = false,
        watch_dir = nil,
    }
    
    -- required to fix code action ranges
    ts_utils.setup_client(client)

    -- Mappings
    local opts = { noremap=true, silent=true }

    buf_set_keymap("n", ",,", ":TSLspFixCurrent<CR>", opts)
    buf_set_keymap("n", ",ai", ":TSLspImportAll<CR>", opts)
    buf_set_keymap("n", ",ao", ":TSLspOrganize<CR>", opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", opts)

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', ',ar', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', ',af', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    buf_set_keymap('n', ',e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    -- buf_set_keymap('n', ',q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    -- buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    -- buf_set_keymap('n', ',a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    -- buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  end,
  flags = {
    debounce_text_changes = 150,
  }
}


require('lspinstall').setup()
local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
  require'lspconfig'[server].setup{
    on_attach = function(client, buffnr)
      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
      local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

      --Enable completion triggered by <c-x><c-o>
      buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
      -- Mappings
      local opts = { noremap=true, silent=true }

      -- See `:help vim.lsp.*` for documentation on any of the below functions
      buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
      buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
      buf_set_keymap('n', ',ar', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      buf_set_keymap('n', ',af', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
      buf_set_keymap('n', ',e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    end,
  }
end

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
" Symbols Outline
"-------------------------------------------------- 
lua << EOF
vim.g.symbols_outline = {
    highlight_hovered_item = true,
    show_guides = true,
    auto_preview = false,
    position = 'left',
    width = 30,
    show_numbers = false,
    show_relative_numbers = false,
    show_symbol_details = true,
    keymaps = { -- These keymaps can be a string or a table for multiple keys
        close = {"<Esc>", "q"},
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "<C-space>",
        toggle_preview = "K",
        rename_symbol = "r",
        code_actions = "a",
    },
    lsp_blacklist = {},
    symbol_blacklist = {},
    symbols = {
        File = {icon = "", hl = "TSURI"},
        Module = {icon = "", hl = "TSNamespace"},
        Namespace = {icon = "", hl = "TSNamespace"},
        Package = {icon = "", hl = "TSNamespace"},
        Class = {icon = "𝓒", hl = "TSType"},
        Method = {icon = "ƒ", hl = "TSMethod"},
        Property = {icon = "", hl = "TSMethod"},
        Field = {icon = "", hl = "TSField"},
        Constructor = {icon = "", hl = "TSConstructor"},
        Enum = {icon = "ℰ", hl = "TSType"},
        Interface = {icon = "ﰮ", hl = "TSType"},
        Function = {icon = "", hl = "TSFunction"},
        Variable = {icon = "", hl = "TSConstant"},
        Constant = {icon = "", hl = "TSConstant"},
        String = {icon = "𝓐", hl = "TSString"},
        Number = {icon = "#", hl = "TSNumber"},
        Boolean = {icon = "⊨", hl = "TSBoolean"},
        Array = {icon = "", hl = "TSConstant"},
        Object = {icon = "⦿", hl = "TSType"},
        Key = {icon = "🔐", hl = "TSType"},
        Null = {icon = "NULL", hl = "TSType"},
        EnumMember = {icon = "", hl = "TSField"},
        Struct = {icon = "𝓢", hl = "TSType"},
        Event = {icon = "🗲", hl = "TSType"},
        Operator = {icon = "+", hl = "TSOperator"},
        TypeParameter = {icon = "𝙏", hl = "TSParameter"}
    }
}
vim.api.nvim_set_keymap(
    'n',
    'go',
    ":SymbolsOutline<CR>",
    {noremap = true, silent = true}
)
EOF

"-------------------------------------------------- 
" LSP Saga
"-------------------------------------------------- 
lua << EOF
--local saga = require 'lspsaga'
--saga.init_lsp_saga()
-- TODO: https://github.com/glepnir/lspsaga.nvim
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
