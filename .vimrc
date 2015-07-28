set ff=unix

" Windows path fix
if has('win32') || has('win64')
    " Make windows use ~/.vim too, I don't want to use _vimfiles
    set runtimepath^=~/.vim
else
    set runtimepath+=~/.vim/bundle/vundle/
endif

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

" Search for word under cursor
"map <F4> :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>
"map <F4> :call Search(expand("<,>")) <Return>
vmap <F4> :call Search(GetSelectionText()) <Return>
nmap <F4> :call Search(SearchText()) <Return>

" Vundle Required
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
set rtp+=$GOROOT/misc/vim
call vundle#rc()

Bundle 'gmarik/vundle'

" Bundles
" Bundle 'git://github.com/Rip-Rip/clang_complete.git'
Bundle 'c.vim'
Bundle 'https://github.com/kien/ctrlp.vim.git'
Bundle 'git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex'
Bundle 'https://github.com/mileszs/ack.vim'
Bundle 'https://github.com/altercation/vim-colors-solarized'
Bundle 'https://github.com/dbakker/vim-projectroot'
Bundle 'https://github.com/majutsushi/tagbar'
Bundle 'https://github.com/nosami/Omnisharp'
Bundle 'https://github.com/tpope/vim-dispatch'
Bundle 'https://github.com/ervandew/supertab'
Bundle 'https://github.com/scrooloose/syntastic'

" Color and Font Setup
if has('gui_running')
  set guioptions-=T  " no toolbar
  "colorscheme navajo-night
  "colorscheme autumn
  "colorscheme dusk
  "colorscheme molokai
  "let g:molokai_original = 1
  "set background=light
  "colorscheme summerfruit256
  
  colorscheme solarized
  "set background=light
  set background=dark
  "let g:solarized_termcolors=256
  
  "set guifont=dejavu\ sans\ mono:h10
  set guifont=bitstream\ vera\ sans\ mono:h10
  set antialias
else
  set t_Co=256
  "colorscheme navajo-night
  "colorscheme autumn
  "colorscheme dusk
  "colorscheme molokai
  "let g:molokai_original = 1
  "set background=light
  "colorscheme summerfruit256

  colorscheme solarized
  "set background=light
  set background=dark
  let g:solarized_termcolors=256

  "set guifont=dejavu\ sans\ mono:h10
  set guifont=bitstream\ vera\ sans\ mono:h10
  set antialias
endif

" Smart Formatting
filetype plugin on
set smartindent
set tabstop=4
set expandtab
set shiftwidth=4
set backspace=2 " make backspace work like most other apps
filetype indent on
set number
"set autochdir
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

" clang
" highlight the warnings and errors
let g:clang_hl_errors = 1
" open quickfix window on error
let g:clang_complete_copen = 1
let g:clang_use_library = 1
map <C-c> :call g:ClangUpdateQuickFix()<CR>

" CtrlP
let g:ctrlp_by_filename = 1
set wildignore+=*/tmp/*,*.so,*.swp,*.zip  " MacOSX/Linux
set wildignore+=tmp\*,*.swp,*.zip,*.exe,*.lib   " Windows
set wildignore+=*/gamedata/* " Valkyrie

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

"Omnisharp
autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
set completeopt=longest,menuone,preview
"set hidden
autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
set updatetime=500
set cmdheight=2
"let g:OmniSharp_autoselect_existing_sln = 0

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
"let g:SuperTabClosePreviewOnPopupClose = 1

"Auto change to project root
au BufEnter * if &ft != 'help' | call ProjectRootCD() | endif
au BufRead,BufNewFile *.lua.txt set syntax=lua

"" Remove all text except what matches the current search result
"" The opposite of :%s///g (which clears all instances of the current search).
function! ClearAllButMatches()
    let old = @x
    let @x=""
    %s//\=setreg('X', submatch(0), 'l')/g
    %d _
    put x
    0d _
    let @x = old
endfunction

function! Search(target, ...)
    let target = a:target

    if(empty(target)) | return | endif

    if a:0 > 0
        let path = a:1
    else
        let path = ProjectRootGuess()
    end

    echo "Searching for: " . path
    ":execute "vimgrep /" . target . "/j " . path . "/**" | cw<Return>
    :execute "Ack " . target . " " . path

endfunction

function! GetSelectionText()
    let old_a = @a
    normal! gv"ay
    let selection = @a
    let @a = old_a

    return selection
endfunction

function! SearchText()
    "let curline = getline('.')
    call inputsave()
    let text = input('Search All: ')
    call inputrestore()
    "call setline('.', curline)
    return text
endfunction
