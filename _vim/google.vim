autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

set textwidth=80
set spelllang=en_us

set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab


