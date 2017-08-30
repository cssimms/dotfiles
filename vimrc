" add lightlineto runtimepath
set runtimepath^=~/.vim/bundle/lightline.vim-master

" Status Line My Goodness!
let g:lightline = {
			\ 'colorscheme': 'solarized',
			\ }
set noshowmode

" Best ColorScheme
colorscheme solarized

" Destroy Esc Lag
set timeoutlen=1000 ttimeoutlen=0

" Auto Indent is Cool
set smartindent
set autoindent

" load indent file for the current filetype
filetype indent on
" Always show statusbar
set laststatus=2

" Show line numbers
set number
syntax on

" Setup Tabs depending on filetype
" by default, the indent is 2 spaces. 
set shiftwidth=2
set softtabstop=2
set tabstop=2

" for html/rb files, 2 spaces
autocmd Filetype html setlocal ts=2 sw=2 expandtab
autocmd Filetype ruby setlocal ts=2 sw=2 expandtab

" for js/coffee files, 4 spaces
autocmd Filetype javascript setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype coffeescript setlocal ts=4 sw=4 sts=0 expandtab


 
 set nocompatible              " be iMproved, required
 filetype off                  " required
 " set the runtime path to include Vundle and initialize
 set rtp+=~/.vim/bundle/Vundle.vim
 call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
 Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.

 Plugin 'bling/vim-airline'

 Plugin 'airblade/vim-gitgutter'

 Plugin 'ayu-theme/ayu-vim'

 call vundle#end()            " required
 filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

syntax on
set number

" Color Scheme Setup
set termguicolors
let ayucolor='dark'
colorscheme ayu

" 
" Key Mappings

" set mapleader
 let mapleader = "\<Space>"
" set copy/paste
 vmap <Leader>y :w !pbcopy<CR>
 nmap <Leader>p :r !pbpaste<CR>

" Use Enter and Shift-Enter to insert newlines without INSERT mode
 nmap <CR> o<Esc>k
 nmap <S-CR> O<Esc>j

" Save quickly
 nmap <Leader>s :w<CR>

" Remove whitespace
 nmap <Leader>ws :%s/[ \t]\+\n/\r/g<CR>



 " Netrw will default to show tree
 let g:netrw_liststyle = 3
 " Backspace was being wierd
set backspace=indent,eol,start
