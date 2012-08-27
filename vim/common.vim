set nospell

set enc=utf-8

syntax on
colorscheme desert

set nospell

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup

set ruler " show the cursor position all the time
set history=100 " keep 50 lines of command line history
set showcmd    " display incomplete commands
set incsearch  " do incremental searching

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

set et

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

set tabstop=2
set shiftwidth=4
set textwidth=80
set expandtab

autocmd FileType text :setlocal textwidth=80

autocmd FileType cweb,text,tex,latex :setlocal spell spelllang=en
autocmd FileType c,cpp,java,js :set cindent
autocmd FileType css :set smartindent
autocmd FileType py,haskell :set autoindent

autocmd FileType c,cpp :compiler gcc
autocmd FileType java :compiler ant

autocmd FileType tex,lua,c,cpp,java,haskell,lhaskell,python,rb :set expandtab
autocmd FileType tex :set foldmethod=marker
autocmd FileType haskell :set foldmethod=syntax

autocmd FileType c,cpp,java,js,py,haskell match ErrorMsg /\%>80v.\+/
autocmd FileType tex,lua,c,cpp,java,haskell,lhaskell,python,rb :set expandtab
" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
                        \ if line("'\"") > 0 && line("'\"") <= line("$") |
                        \   exe "normal g`\"" |
                        \ endif

set enc=utf-8
"set wrap
"set linebreak
set mousemodel=extend
let xml_use_xhtml=1

" Project plugin settings

let g:proj_window_width=32
let g:proj_window_increment=24
let g:proj_flags='imstL'

highlight WhitespaceEOL ctermbg=lightgray guibg=lightgray
match WhitespaceEOL /s+$/

set shellslash
set grepprg=grep\ -nH\ $*

let g:Tex_ViewRule_pdf = 'open'
let g:Tex_ViewRule_ps = 'open'
let g:Tex_ViewRule_dvi = 'open'

let g:load_doxygen_syntax=1

let g:proj_run1 = 'make'
let g:proj_run2 = '!cmake .'
let g:proj_run3 = 'make test'

let g:AutoComplPop_NotEnableAtStartup = 1