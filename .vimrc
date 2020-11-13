set ff=unix

let mapleader = "\<Space>"

" Copy+Paste Support
if has('win32')
    set mouse=a
    source $VIMRUNTIME/mswin.vim
endif

" Modify Middle Mouse
"map <C-MiddleMouse> "*p
vmap <C-MiddleMouse> "*y
imap <C-MiddleMouse> <C-R>+
noremap <MiddleMouse> <LeftMouse>
map <2-MiddleMouse> <Nop>
imap <2-MiddleMouse> <Nop>
map <3-MiddleMouse> <Nop>
imap <3-MiddleMouse> <Nop>
map <4-MiddleMouse> <Nop>
imap <4-MiddleMouse> <Nop>

" Plugins
if has('nvim')
    call plug#begin(stdpath('data') . '/plugged')
else
    call plug#begin('~/.vim/plugged')
endif

Plug 'https://github.com/easymotion/vim-easymotion'
Plug 'https://github.com/majutsushi/tagbar'
Plug 'https://github.com/scrooloose/nerdtree'
Plug 'https://github.com/junegunn/fzf'
Plug 'https://github.com/junegunn/fzf.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/vim-airline/vim-airline-themes'
Plug 'https://github.com/rcabralc/monokai-airline.vim'

Plug 'https://github.com/icymind/NeoSolarized'
Plug 'https://github.com/crusoexia/vim-monokai'
Plug 'https://github.com/altercation/vim-colors-solarized'
Plug 'https://github.com/ayu-theme/ayu-vim'
Plug 'https://github.com/drewtempelmeyer/palenight.vim'
call plug#end()

filetype plugin indent on

""""""""""""""""""""""""""""""""""""""""""""""""
" LSP
""""""""""""""""""""""""""""""""""""""""""""""""
if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ })
endif

if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '-background-index']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""
" vim-easymotion
""""""""""""""""""""""""""""""""""""""""""""""""
" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)
" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)
" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)
" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)
""""""""""""""""""""""""""""""""""""""""""""""""

" Color and Font Setup
colorscheme palenight
set termguicolors     " enable true colors support
set background=dark
"colorscheme one
set guifont="Noto Mono:h10"

" Smart Formatting
set smartindent
set tabstop=4
set expandtab
set shiftwidth=4
set backspace=2 " make backspace work like most other apps
set number
syntax enable

" Status Bar
set laststatus=2        "Makes status line always appear
set statusline=
set statusline+=%F       "tail of the filename
set statusline+=\ \ \ \       "spaces
set statusline+=Line:\ %l/%L   "cursor line/total lines
set statusline+=[%P]    "percent through file
set statusline+=\       "Space
set statusline+=Col:\ %c     "cursor column
set statusline+=\       "space
set statusline+=Buf:\ #%n
set statusline+=\ \ \ \       "space
set statusline+=[%b][0x%B] "Value under cursor
set statusline+=%=      "left/right separato
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetyper

" Folding
set foldmethod=syntax

" Disable writing to default register on p
xnoremap p pgvy

if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8
    set fileencodings=ucs-bom,utf-8,latin1
endif

"""""""""""""""""""""""""""""""""""""""""""""""""
" FZF
"""""""""""""""""""""""""""""""""""""""""""""""""
" Reverse the layout to make the FZF list top-down
let $FZF_DEFAULT_OPTS='--color=dark --layout=reverse --margin 1,4'

" Using the custom window creation function
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

" Customize fzf colors to match your color scheme
" 'info':    ['fg', 'PreProc'],
" 'prompt':  ['fg', 'Conditional'],
" \ 'header':  ['fg', 'Comment'] }
" \ 'bg':      ['bg', 'Normal'],
let g:fzf_colors =
	\ { 'fg':      ['fg', 'Normal'],
	\ 'bg':      ['bg', -1],
	\ 'hl':      ['fg', 'Comment'],
	\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
	\ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
	\ 'hl+':     ['fg', 'Statement'],
	\ 'info':    ['fg', 0],
	\ 'border':  ['fg', 'Ignore'],
	\ 'prompt':  ['fg', 0],
	\ 'pointer': ['fg', 'Exception'],
	\ 'marker':  ['fg', 'Keyword'],
	\ 'spinner': ['fg', 'Label'],
	\ 'header':  ['fg', -1] }

" Function to create the custom floating window
function! FloatingFZF()
    " creates a scratch, unlisted, new, empty, unnamed buffer
    " to be used in the floating window
    let buf = nvim_create_buf(v:false, v:true)
    call setbufvar(buf, '&signcolumn', 'no')
    " 90% of the height
    let height = float2nr(&lines * 0.9)
    " 60% of the width
    let width = float2nr(&columns * 0.8)
    " horizontal position (centralized)
    let horizontal = float2nr((&columns - width) / 2)
    " vertical position (one line down of the top)
    let vertical = 1
    let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal'
        \ }
    " open the new window, floating, and enter to it
    call nvim_open_win(buf, v:true, opts)
endfunction

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

nnoremap <Leader>a :Ag<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>g :GFiles<CR>
nnoremap <Leader>f :Lines<CR>

command! -bang -nargs=? GFiles call fzf#vim#gitfiles(<q-args>)
command! -bang -nargs=* Ag                        call fzf#vim#ag(<q-args>)
command! -bang -nargs=* Rg                        call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>), 1)
command! -bang -nargs=* Rgu                       call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -t cpp -t cs -g '!Tests/*' -g '!Documentation/*' -- ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
command! -bar -bang -nargs=? -complete=buffer Buffers  call fzf#vim#buffers(<q-args>)
nnoremap <silent> <Leader>f :call fzf#vim#files('', fzf#vim#with_preview({'options': '--prompt ""'}, 'right:70%')) <CR>

"Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='monokai'
"let g:airline_powerline_fonts=1

" Tags settings
"set tags=.tags;
