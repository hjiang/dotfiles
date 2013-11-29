" This must be first, because it changes other options as a side effect.
set nocompatible

filetype off                  " required by Vundle

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

filetype plugin indent on  " required by Vundle

source ~/.vim/functions.vim
source ~/.vim/common.vim
