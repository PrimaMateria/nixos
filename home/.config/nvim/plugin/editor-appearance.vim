"-------------------------------------------------- 
" Color scheme
"-------------------------------------------------- 
"let g:neotrix_dark_contrast = "retro_hard"
"colorscheme neotrix

"set background=dark
"colorscheme gruvbox

"augroup customColorScheme
   "autocmd!
   "" highlight-groups
   "autocmd ColorScheme * highlight Normal guibg=black
   "autocmd ColorScheme * highlight EndOfBuffer guibg=black
   "autocmd ColorScheme * highlight CursorLine guibg=#333333
   "autocmd ColorScheme * highlight CursorColumn guibg=#111111
   "autocmd ColorScheme * highlight Visual guibg=#555555
   "autocmd ColorScheme * highlight TabLineFill guifg=#444444 guibg=black
   "autocmd ColorScheme * highlight TabLine gui=NONE guifg=white guibg=#444444
   "autocmd ColorScheme * highlight TabLineSel gui=NONE guifg=yellow guibg=#444444
"augroup END

"-------------------------------------------------- 
" Sonokai Color scheme
"-------------------------------------------------- 
" Sonokai doesn't respect highlight groups autocommands. It requires special
" overrides.

"if has('termguicolors')
"  set termguicolors
"endif
"
"function! s:sonokai_custom() abort
"  let l:palette = sonokai#get_palette('atlantis')
"  let l:myPalette = {
"     \ 'cursorColumn': ['#222222', '999', 'DarkGrey']
"     \ }
"
"  " Define a highlight group.
"  " The first parameter is the name of a highlight group,
"  " the second parameter is the foreground color,
"  " the third parameter is the background color,
"  " the fourth parameter is for UI highlighting which is optional,
"  " and the last parameter is for `guisp` which is also optional.
"  " See `autoload/sonokai.vim` for the format of `l:palette`.
"  call sonokai#highlight('CursorColumn', l:palette.none, l:myPalette.cursorColumn , 'NONE', 'NONE')
"endfunction

"let g:sonokai_stye = 'default'
"let g:sonokai_enable_italic = 1
"let g:sonokai_transparent_background = 1

"augroup SonokaiCustom
  "autocmd!
  "autocmd ColorScheme sonokai call s:sonokai_custom()
"augroup END

"colorscheme sonokai

"-------------------------------------------------- 
" Gruvbox community Color scheme
"-------------------------------------------------- 
"set background=dark
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

"augroup gruvboxColorScheme
   "autocmd!
   " highlight-groups
   "autocmd ColorScheme * highlight Normal guibg=black
   "autocmd ColorScheme * highlight EndOfBuffer guibg=black
   "autocmd ColorScheme * highlight CursorLine guibg=#222222
   "autocmd ColorScheme * highlight CursorColumn guibg=#1A1A1A
   "autocmd ColorScheme * highlight Visual guibg=#555555
   "autocmd ColorScheme * highlight TabLineFill guifg=#444444 guibg=black
   "autocmd ColorScheme * highlight TabLine gui=NONE guifg=white guibg=#444444
   "autocmd ColorScheme * highlight TabLineSel gui=NONE guifg=yellow guibg=#444444
"augroup END

"-------------------------------------------------- 
" Lightline
"-------------------------------------------------- 
" seoul256
let g:lightline = {
  \ 'colorscheme': 'sonokai',
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
" Terminal color scheme
"-------------------------------------------------- 
" Taken from toast.vim
" let g:terminal_color_1  = "#D12D00"
" let g:terminal_color_2  = "#427B00"
" let g:terminal_color_3  = "#B68200"
" let g:terminal_color_4  = "#006fd1"
" let g:terminal_color_5  = "#a53bce"
" let g:terminal_color_6  = "#119c97"
" let g:terminal_color_9  = "#E74D23"
" let g:terminal_color_10 = "#7dc030"
" let g:terminal_color_11 = "#ffc233"
" let g:terminal_color_12 = "#5aa2e0"
" let g:terminal_color_13 = "#b968d9"
" let g:terminal_color_14 = "#15c1bb"

