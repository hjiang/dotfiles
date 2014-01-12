" This must be first, because it changes other options as a side effect.
set nocompatible

filetype off                  " required by Vundle

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'
Bundle 'groenewege/vim-less'
Bundle 'AutoClose'

filetype plugin indent on  " required by Vundle

au BufRead,BufNewFile *.ejs setfiletype html

source ~/.vim/functions.vim
source ~/.vim/common.vim
