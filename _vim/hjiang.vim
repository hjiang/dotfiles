" If you want syntax highlighting enabled, you should enable it *before*
" sourcing this script by adding "syntax on" to your .vimrc

" Add <mydir>/runtime and <mydir>/runtime/after to appropiate places in Vim's
" runtimepath. The former is made the second element, while the latter is made
" the second to last element.

runtime coding-style.vim
runtime gcheckstyle.vim

let s:marked_line_on_screen = 0

" Trims excess newlines from the end of the buffer.  Also adds a newline if the
" last line doesn't have one.
function! GoogleTrimNewlines ()
  let lines = line('$')
  let done = 0
  " loop so that we can also delete trailing lines consisting of only whitespace
  while !done
    " erase last line if it's only whitespace
    %s/^\s*\%$//e

    " erase trailing blank lines
    %s/\n*\%$/\r/e
    %s/\n*\%$//e

    " if we actually did anything, assume that we have more to do
    let done = lines == line('$')
    let lines = line('$')
  endwhile
endfunction

" Trim spaces at the end of line (lint complains if they exist)
function! GoogleTrimEOLSpaces ()
    :%s/\s\+$//eg
endfunction

function! GoogleMarkCurrPos ()
  " mark the curr position, as well as the first visible character on that
  " line. We need the latter because certain sorts of window decorations (eg:
  " 'number') can cause the first position to be non-zero.
  normal! mzg0my

  " remember the marked position wrt the screen
  let s:marked_col_on_screen = wincol()
  let s:marked_line_on_screen = winline()
endfunction

function! GoogleRestorePos ()
  " jump back to the old "first character on the line", and remember offsets
  silent! normal! `y
  let col_offset = wincol() - s:marked_col_on_screen
  let line_offset = winline() - s:marked_line_on_screen

  " jump to actual marked position
  silent! normal! `z

  " scroll window to correct for offsets
  if col_offset < 0
    exe "normal! " . -col_offset . "zh"
  elseif col_offset > 0
    exe "normal! " . col_offset . "zl"
  endif
  if line_offset < 0
    exe "normal! " . -line_offset . "\<C-Y>"
  elseif line_offset > 0
    exe "normal! " . line_offset . "\<C-E>"
  endif
endfunction

" Trims newlines and at the end of the file if this is a file of an appropriate
" type.
function! GoogleConditionallyTrimNewlines ()
  if &ft == 'cpp' || &ft == 'c' || &ft == 'java' || &ft == 'python' || &ft == 'make'
    if match(getline('$'), '^\s*$') >= 0
      call GoogleMarkCurrPos()
      call GoogleTrimNewlines()
      call GoogleRestorePos()
    endif
  endif
endfunction

" Trim newlines at the end of certain files before saving
au BufWritePre * call GoogleConditionallyTrimNewlines()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" You can turn off automatic boilerplate generation by adding the
" following command to your .vimrc *before* sourcing google.vim:
"
"    let  g:disable_google_boilerplate=1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" function! Autogen(fnam)
"   exe '.!/home/build/public/google/tools/autogen ' . a:fnam . ' 2>/dev/null'
"   $
"   silent ?^\s*$
"   normal! $
" endfunction

" command! Autogen call Autogen(expand('%'))

" if ! exists('g:disable_google_boilerplate') || ! g:disable_google_boilerplate
"   aug google_boilerplate
"   autocmd BufNewFile * silent! Autogen
"   aug END
" endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" The following settings are optional, but recommended. You may wish to
" override these options in your personal .vimrc after sourcing this file.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" enables extra vim features (which break strict compatibility with vi)
set nocompatible

" allows files to be open in invisible buffers
set hidden

" show trailing spaces in yellow. "set nolist" to disable this.
" this only works if syntax highlighting is enabled.
set list
set listchars=tab:\ \ ,trail:\ ,extends:»,precedes:«
highlight SpecialKey ctermbg=Yellow guibg=Yellow
" if you would like to make tabs and trailing spaces visible without syntax
" highlighting, use this:
"   set listchars=tab:·\ ,trail:\·,extends:»,precedes:«

" make backspace "more powerful"
set backspace=indent,eol,start

let is_bash=1                  " informs sh syntax that /bin/sh is actually bash
let java_allow_cpp_keywords=1  " don't highlight C++ kewords as errors in Java
let java_highlight_functions=1 " highlight method decls in Java (when syntax on)
