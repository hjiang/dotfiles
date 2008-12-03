
" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set nospell

set enc=utf-8

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup " do not keep a backup file, use versions instead
else
  set backup " keep a backup file
endif
set history=50 " keep 50 lines of command line history
set ruler      " show the cursor position all the time
set showcmd    " display incomplete commands
set incsearch  " do incremental searching

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

set textwidth=80
set et

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 76 characters.
  autocmd FileType text :setlocal textwidth=76

  autocmd FileType cweb,text,tex,latex :setlocal spell spelllang=en
  autocmd FileType c,cpp,java,js :set cindent
  autocmd FileType c,cpp,java,js :set expandtab
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

  augroup END

else

set smartindent		" always set autoindenting on

endif " has("autocmd")

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

autocmd FileType c,cpp iabbrev for for (!cursor!; <+++>; <+++>) {<cr><+++><cr>}<Esc>:call search('!cursor!','b')<cr>cf!

nnoremap <c-j> /<+.\{-1,}+><cr>c/+>/e<cr> 
inoremap <c-j> <ESC>/<+.\{-1,}+><cr>c/+>/e<cr> 
match Todo /<+.\++>/

" No indent after C++ namespace
setlocal nolisp
setlocal noautoindent
setlocal indentexpr=GetCppIndent(v:lnum)

if exists("*GetCppIndent")
    finish
endif

function! GetCppIndent(lnum)
    let cindent = cindent(a:lnum)
    if a:lnum == 1 | return cindent | endif

    let pattern1 = 'namespace\s\+\S\*\s*{\s*\%$'
    " pattern2 is used to match this case:
    " class c : public b
    "     { <-- cursor
    let clspat = 'class\s\+\S\*\s*:\s*[^{]*'
    let pattern2 = 'namespace\s\+\S\*\s*{\s*'.clspat.'\%$'

    let lines = join(getline(max([ a:lnum - 10, 1]) , a:lnum-1), ' ')

    if  lines =~ pattern1
        return indent(CppFindOccurence('namespace', a:lnum))
    elseif  lines =~ pattern2 && getline(a:lnum) =~ '^\s*{'
        return indent(CppFindOccurence('class', a:lnum))
    else
        return cindent
    endif
endfunction

function! CppFindOccurence(pattern, lnum)
    for line in range(a:lnum-1,a:lnum-10,-1)
        if getline(line) =~ a:pattern
            return line
        endif
    endfor
    return -1
endfunction
