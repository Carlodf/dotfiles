"Vundle -------------------------------------------------------------------{{{1
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
" calls vundle and set the root installation path for plugins
call vundle#begin('~/.vim/bundles')

"Plugins ------------------------------------------------------------------{{{2
Plugin 'VundleVim/Vundle.vim' "plugin manager
Plugin 'sjl/gundo.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
"Plugin 'ervandew/supertab'
Plugin 'SirVer/ultisnips'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


" Beginning of vim configurations

" Genreal settings --------------------------------------------------------{{{1

set encoding=utf-8
" makes 3 lines above and below current line always visible
set scrolloff=3
" Automatically copies the indent in a new line
set autoindent
set showcmd
" Enables command autocompletion
set wildmenu
set wildmode=list,full
" Highlight cursor line
set cursorline
"status line always on
set laststatus=2
" line numbers on side
set relativenumber number
" open vertical split on right
set splitright
" search incremental and highlight
set incsearch hlsearch
" tabs settings
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
" show invisible characters
set list
" enavle undofile
set undofile
set undodir=~/.vim/undo/
" set directory for swap files
set directory=~/.vim/swp/
" show diff in vertical split and use filler for deleted lines
set diffopt=filler,vertical
set visualbell

" Set folding based on marker for vim files
augroup vim_file_group
    autocmd!
    autocmd Filetype vim setlocal foldmethod=marker
augroup END

" Settings for ultisnip plugin --------------------------------------------{{{2
" Trigger configuration.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" :UltiSnipsEdit opens to a split window.
let g:UltiSnipsEditSplit="vertical"

" Mappings ----------------------------------------------------------------{{{1

let mapleader="\\"
let maplocalleader="_"

" fast operations on vimrc file
nnoremap <leader>ev :vsplit $MYVIMRC <cr>
nnoremap <leader>sv :source $MYVIMRC <cr>

" Mapping to train
inoremap jk <esc>
inoremap <esc> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
nnoremap OA <nop>
nnoremap OB <nop>
nnoremap OC <nop>
nnoremap OD <nop>

" easier mappings for moving within splits
nnoremap <c-h> <c-w><c-h>
nnoremap <c-l> <c-w><c-l>
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>

" go to next and center page
nnoremap n nzz
nnoremap N Nzz

" remap for nohlsearch
nnoremap <silent> <esc> :nohlsearch <cr>
" toggle case of a word in insertmode
inoremap <c-u> <esc>mmviw~`mli
" toggle case of a word in normalmode
nnoremap <leader>u mmviw~`m
" adds quotes to a word in insert mode
nnoremap <leader>" bi"<esc>ea"<esc>
" call functionto delete trailing spaces
nnoremap <silent> <leader>dts :call <SID>StripTrailingWhitespaces()<CR>
" call functionto toggle quickfix window
nnoremap <leader>qf :call <SID>QuickfixToggle()<cr>
" grep operators to be used with motions
nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>

" mapping for Gundo
nnoremap <F5> :GundoToggle<cr>
" maps to F5 on my mac keyboard
nnoremap [15~ :GundoToggle<cr>

" Appareance --------------------------------------------------------------{{{1

syntax enable
colorscheme badwolf

" Highlight columns 80 and 120
let &colorcolumn="80,".join(range(120,120),",")

" show diffs in verticall splits and fill empty lines
set diffopt=vertical,filler

" custom character to be shown for invisible characters
set listchars=tab:▸\ ,eol:¬

"Airline settings ---------------------------------------------------------{{{2
let g:airline_theme= 'badwolf'


" Functions ---------------------------------------------------------------{{{1

" define a grep operator to be used with movements
function! s:GrepOperator(type)
    let saved_unamed_register = @@
    if a:type ==# 'v'
        execute "normal! `<v`>y"
    elseif a:type ==# 'char'
        execute "normal! `[v`]y"
    else
        return
    endif

    silent execute "grep! -R " . shellescape(@@) . " ."
    copen
    let @@ = saved_unamed_register
endfunction

" deletes triling whitespaces
function! s:StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let saved_search_history=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/= saved_search_history
    call cursor(l, c)
endfunction

" bunch of specific remappings for cpp files.
augroup cppfiles
    augroup !
    " Fix typos for :: in cpp files
    autocmd Filetype cpp inoremap <buffer> ;: ::
    autocmd Filetype cpp inoremap <buffer> :; ::
    autocmd Filetype cpp inoremap <buffer> ;; ::
    " Auto close parenthesis and quotes
    autocmd Filetype cpp inoremap <buffer> {<cr> {<cr>}<esc>O
    autocmd Filetype cpp inoremap <buffer> (<space> ()<esc>i
    autocmd Filetype cpp inoremap <buffer> <<space> <><esc>i
    autocmd Filetype cpp inoremap <buffer> "<space> ""<esc>i
augroup END

" Toggles quick fix window open/close
let g:quickfix_is_open = 0

function! s:QuickfixToggle()
    if g:quickfix_is_open
        cclose
        let g:quickfix_is_open = 0
        execute g:quickfix_return_to_window . "wincmd w"
    else
        let g:quickfix_return_to_window = winnr()
        copen
        let g:quickfix_is_open = 1
    endif
endfunction

:source ~/.vim/experimental.vim
