set ff=unix

let mapleader = "\<Space>"

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

" FZF
set rtp+=/usr/local/opt/fzf

Plugin 'VundleVim/Vundle.vim'

" Plugins
Plugin 'https://github.com/kien/ctrlp.vim.git'
Plugin 'https://github.com/mileszs/ack.vim'
Plugin 'https://github.com/dbakker/vim-projectroot'
Plugin 'https://github.com/vim-airline/vim-airline'
Plugin 'https://github.com/vim-airline/vim-airline-themes'
Plugin 'https://github.com/rcabralc/monokai-airline.vim'
Plugin 'https://github.com/easymotion/vim-easymotion'
Plugin 'https://github.com/xolox/vim-misc'

Plugin 'https://github.com/icymind/NeoSolarized'
Plugin 'https://github.com/crusoexia/vim-monokai'
Plugin 'https://github.com/altercation/vim-colors-solarized'

Plugin 'https://github.com/majutsushi/tagbar'
Plugin 'https://github.com/scrooloose/nerdtree'

Plugin 'https://github.com/ayu-theme/ayu-vim'
Plugin 'https://github.com/drewtempelmeyer/palenight.vim'

Plugin 'https://github.com/junegunn/fzf.vim'

call vundle#end()
filetype plugin indent on

" Color and Font Setup
set t_Co=256
colorscheme palenight
set termguicolors     " enable true colors support
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

" CtrlP
"let g:ctrlp_by_filename = 1
set wildignore+=*/tmp/*,*.so,*.swp,*.zip  " MacOSX/Linux
set wildignore+=tmp\*,*.swp,*.zip,*.exe,*.lib   " Windows
let g:ctrlp_working_path_mode = 'r'
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8
    set fileencodings=ucs-bom,utf-8,latin1
endif

" LeaderF to use CtrlP
let g:Lf_ShortcutF = '<C-P>'
nmap <C-O> :LeaderfBuffer<CR><Tab>

" FZF Keys
nnoremap <Leader>a :Ag<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>g :GFiles<CR>
nnoremap <Leader>f :Lines<CR>

"ack.vim
"let g:ackprg = 'ag --vimgrep --path-to-ignore .hg/.hgignore.local'
"cnoreabbrev Ack Ack!
"nnoremap <Leader>a :Ack!<Space>

"Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='monokai'
"let g:airline_powerline_fonts=1

" Tags settings
set tags=.tags;
