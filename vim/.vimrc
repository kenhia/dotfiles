call plug#begin('~/.vim/plugged')

Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'
Plug 'bronson/vim-trailing-whitespace'

" Unite
"   depend on vimproc
"   ------------- VERY IMPORTANT ------------
"   you have to go to .vim/plugin/vimproc.vim and do a ./make
"   -----------------------------------------
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'Shougo/unite.vim'

call plug#end()

" -- grubbox personal conf
set background=dark
try
   let g:gruvbox_termcolors = 256
   let g:gruvbox_contrast_dark = 'hard'

   if (getenv('TERM_PROGRAM') != 'Apple_Terminal')
        if (has("nvim"))
            let $NVIM_TUI_ENABLE_TRUE_COLOR=1
        endif
        if (has("termguicolors"))
            set termguicolors
        endif
    endif

    colorscheme gruvbox
catch
endtry

" -- smarter tabs (as spaces!)
set shiftwidth=4 smarttab
set expandtab
set tabstop=8 softtabstop=0

" -- show col 80
if (exists('+colorcolumn'))
    set colorcolumn=80
    highlight ColorColumn ctermbg=9
endif

" -- unite configuration
let g:unite_source_history_yank_enable = 1
try
    let g:unite_source_rec_async_command='ag --nocolor --nogroup -g ""'
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
catch
endtry
" search a file in the filetree
" nnoremap <space><space> :split<cr> :<C-u>Unite -start-insert file_rec/async<cr>
" reset not it is <C-l> normally
" :nnoremap <space>r <Plug>(unite_restart)

" -- vim look and feel
set laststatus=2
set backspace=indent,eol,start
set number
set relativenumber

