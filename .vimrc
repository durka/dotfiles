set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" todo clean up plugins
Bundle 'gmarik/vundle'
Bundle 'scrooloose/nerdtree'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-repeat'
Bundle 'vim-scripts/Align'
Bundle 'sjl/gundo.vim'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'tpope/vim-fireplace'
Bundle 'tpope/vim-classpath'
Bundle 'guns/vim-clojure-static'
Bundle 'xolox/vim-misc'
Bundle 'xolox/vim-session'
Bundle 'mhinz/vim-startify'
Bundle 'vim-scripts/calendar.vim--Matsumoto'
Bundle 'jamessan/vim-gnupg'
Bundle 'jmcantrell/vim-journal'
Bundle 'bling/vim-airline'
Bundle 'justinmk/vim-sneak'
Bundle 'osyo-manga/vim-over'
Bundle 'goldfeld/vim-seek'
Bundle 'ConradIrwin/vim-bracketed-paste'
Bundle 'junegunn/vim-easy-align'
Bundle 'tpope/vim-afterimage'
Plugin 'rust-lang/rust.vim'
Plugin 'chiphogg/vim-prototxt'
Bundle 'phildawes/racer'
Bundle 'vim-scripts/lojban'
Plugin 'bhurlow/vim-parinfer'
Plugin 'Valloric/YouCompleteMe'
Plugin 'kopischke/vim-fetch'
Plugin 'goldfeld/ctrlr.vim'
Plugin 'kana/vim-textobj-user'
Plugin 'rhysd/vim-textobj-anyblock'

" for vundle and vim-latex
filetype plugin indent on

" for me
set tabstop=4 shiftwidth=4 expandtab autoindent
syntax on
colorscheme desert
highlight clear SignColumn
set iskeyword-=: " fix python syntax highlighting
if has("osx")
    function! VisualSay() range
        let n = @n
        silent! normal gv"ny
        echo system("say \"" . @n . "\" &")
        let @n = n
    endfunction
    vnoremap <silent> S :call VisualSay()<CR>
endif

" random mapping
" swap current word with next (cursor moves with word)
:nnoremap <silent> gr "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o>/\w\+\_W\+<CR><c-l>

" code and prose (http://alols.github.com/2012/11/07/writing-prose-with-vim/)
noremap Q gqap
command! Prose inoremap <buffer> . .<C-G>u|
             \ inoremap <buffer> ! !<C-G>u|
             \ inoremap <buffer> ? ?<C-G>u|
             \ setlocal spell spelllang=en,es
             \     nolist wrap linebreak tw=100 fo=1 nonu|
             \ augroup PROSE|
             \   autocmd InsertEnter <buffer> set fo+=a|
             \   autocmd InsertLeave <buffer> set fo-=a|
             \ augroup END

command! Code silent! iunmap <buffer> .|
            \ silent! iunmap <buffer> !|
            \ silent! iunmap <buffer> ?|
            \ setlocal nospell list nowrap
            \     tw=74 fo=cqr1 showbreak=… nu|
            \ silent! autocmd! PROSE * <buffer>

" for vim-over
let b:over = "off"
if has("gui")
    function! Over()
        if b:over == "off"
            cabbrev %s OverCommandLine<cr>%s
            cabbrev '<,'>s OverCommandLine<cr>'<,'>s
            let b:over = "on"
        else
            cunabbrev %s
            cunabbrev '<,'>s
            let b:over = "off"
        endif
    endfunction
    call Over()
endif

" for vim-journal
let g:journal_directory = "~/.secret"
let g:journal_encrypted = 1
let g:GPGDefaultRecipients = ['Alex Burka']

" for rust
set hidden
au BufNewFile,BufRead Cargo.toml set ft=config
au BufNewFile,BufRead Cargo.lock set ft=config
au FileType rust compiler cargo
let g:ycm_rust_src_path = '/Users/alex/Programming/rust/rust/src'

" fix some annoyances
set backspace=indent,eol,start
set splitbelow
set splitright
nnoremap Y y$
set gdefault
set smartcase
set linebreak
set guitablabel=
let g:session_autosave = 'no'
set ruler
set tabpagemax=100
set mouse=a

