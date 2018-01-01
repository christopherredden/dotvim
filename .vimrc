set ff=unix

let mapleader = ","

" Bindings
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
map <S-F3> :call ClearAllButMatches() <Return>
nmap <F8> :TagbarToggle<CR>

" Vundle Required
set nocompatible
filetype off

if has('nvim')
    set rtp+=~/.config/nvim/bundle/Vundle.vim
    call vundle#begin("~/.config/nvim/bundle")
else
    call vundle#begin()
endif

Plugin 'VundleVim/Vundle.vim'

" Plugins
Plugin 'c.vim'
Plugin 'https://github.com/kien/ctrlp.vim.git'
Plugin 'https://github.com/mileszs/ack.vim'
Plugin 'https://github.com/altercation/vim-colors-solarized'
Plugin 'https://github.com/dbakker/vim-projectroot'
Plugin 'https://github.com/ervandew/supertab'
Plugin 'https://github.com/vim-airline/vim-airline'
Plugin 'https://github.com/vim-airline/vim-airline-themes'
Plugin 'https://github.com/majutsushi/tagbar'
Plugin 'https://github.com/easymotion/vim-easymotion'
Plugin 'https://github.com/icymind/NeoSolarized'

call vundle#end()
filetype plugin indent on

" Color and Font Setup
if has('gui_vimr')
  set guioptions-=T  " no toolbar
  colorscheme NeoSolarized
  set background=dark
  "let g:solarized_termcolors=256
  
  "set guifont=dejavu\ sans\ mono:h10
  "set guifont=bitstream\ vera\ sans\ mono:h10
  "set guifont=consolas:h12
  "set guifont=droid\ sans\ mono:h12
  "set guifontwide=hiragino\ sans\ mono:h12
  "set guifontset
  "set antialias
elseif has('gui_running')
  set guioptions-=T  " no toolbar
  colorscheme solarized
  set background=dark
  "let g:solarized_termcolors=256
  
  "set guifont=dejavu\ sans\ mono:h10
  "set guifont=bitstream\ vera\ sans\ mono:h10
  "set guifont=consolas:h12
  set guifont=droid\ sans\ mono:h12
  set guifontwide=hiragino\ sans\ mono:h12
  set guifontset
  set antialias
else
  set t_Co=256
  colorscheme solarized
  set background=dark
  let g:solarized_termcolors=256
  set guifont=bitstream\ vera\ sans\ mono:h10
endif

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

" CtrlP
"let g:ctrlp_by_filename = 1
set wildignore+=*/tmp/*,*.so,*.swp,*.zip  " MacOSX/Linux
set wildignore+=tmp\*,*.swp,*.zip,*.exe,*.lib   " Windows
let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_root_markers = ['.projectroot']
let g:ctrlp_custom_ignore = '\v\.(unity|prefab|meta|dll|so|exe|lib|zip|png|dds|fbx|dae)$'

if has('win32') || has('win64')
	"let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d | findstr .*\.lua$' "Lua
end

if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8
    "setglobal bomb
    set fileencodings=ucs-bom,utf-8,latin1
endif

"ack.vim
let g:ackprg = 'ag --nogroup --nocolor --column'

" Keys
" Add syntax highlighting for types and interfaces
nnoremap <leader>th :OmniSharpHighlightTypes<cr>
autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
nnoremap <leader>fi :OmniSharpFindImplementations<cr>
nnoremap <leader>ft :OmniSharpFindType<cr>
nnoremap <leader>fs :OmniSharpFindSymbol<cr>
nnoremap <leader>fu :OmniSharpFindUsages<cr>
nnoremap <leader>fm :OmniSharpFindMembersInBuffer<cr>
" cursor can be anywhere on the line containing an issue for this one
nnoremap <leader>x  :OmniSharpFixIssue<cr>
nnoremap <leader>tt :OmniSharpTypeLookup<cr>
nnoremap <leader>dc :OmniSharpDocumentation<cr>

"Supertab
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabDefaultCompletionTypeDiscovery = ["&omnifunc:<c-x><c-o>","&completefunc:<c-x><c-n>"]

"Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='solarized'
let g:airline_powerline_fonts = 1

"Auto change to project root
au BufEnter * if &ft != 'help' | call ProjectRootCD() | endif
au BufRead,BufNewFile *.lua.txt set syntax=lua
