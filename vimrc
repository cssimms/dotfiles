
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
set runtimepath^=~/.vim/bundle/ctrlp.vim

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

Plugin 'Yggdroot/indentLine'

Plugin 'tpope/vim-surround'

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
set autoread

" Color Scheme Setup
syntax enable
set background=dark
set termguicolors
let ayucolor='dark'
colorscheme ayu

" Set Tabs to be Better
set ts=2 sts=2 sw=2 expandtab
" IndentLine 
let g:indentLine_char = '|'
let g:indentLine_first_char = '|'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_setColors = 0
"
" Make Backspace not Stupid
set backspace=indent,eol,start

" Use Enter and Shift-Enter to insert newlines without INSERT mode
nmap <CR> o<Esc>k
" this one doesn't work :(
nmap <S-CR> O<Esc>j 

" Show Autocomplete Different
set wildmenu
set wildmode=list:longest,full

" from :h ins-completion, tab to auto complete

function! CleverTab()
   if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
      return "\<Tab>"
   else
      return "\<C-N>"
   endif
endfunction
inoremap <Tab> <C-R>=CleverTab()<CR>

inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))

" Attempt to prevent Netrw from staying open
autocmd FileType netrw setl bufhidden=delete

" LEADER MAPPINGS
" set mapleader
let mapleader = "\<Space>"

" General Use Commands
" set save
nmap <Leader>s :w<CR>
vmap <Leader>s :w<CR>

" set copy/paste
vmap <Leader>y :w !pbcopy<CR>
"nmap <Leader>p :r !pbpaste<CR>

" Window Splitting and Nav
set splitbelow
set splitright
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" From StackOverflow - strip whitespace and return cursor
function! StripTrailingWhitespace()
    " Save cursor position
    let l:save = winsaveview()
    " Remove trailing whitespace
    %s/[ \t]\+\n/\r/gc
    " Move cursor to original position
    call winrestview(l:save)
    echo "Stripped trailing whitespace"
endfunction

" Remove Trailing Whitespace Search and Replace
nmap <Leader>ws :call StripTrailingWhitespace()<CR>
" nmap <Leader>ws :%s/[ \t]\+\n/\r/gc<CR>

" Testing Specific Commands
" Add or Remove Test Tag at top of File and Write to File
nmap <Leader>tes gg/do<CR>i,<Space>test:true<Space><Esc>:w<CR>
nmap <Leader>rtes gg/,<Space>test:<CR>4dw:w<CR>

" Insert or remove Byebug
nmap <Leader>d obyebug<Esc>:w<CR>
nmap <Leader>rd /byebug<CR>dd:w<CR>

" Snippet for response and data from http request
nmap <Leader>post oresponse = http_post "#{@base_url}/", body.to_json, @headers<CR>data = JSON.parse response<Esc>k^f/
nmap <Leader>get oresponse = http_get "#{@base_url}/", @headers<CR>data = JSON.parse response<Esc>k^f/

" Post an empty user
nmap <Leader>use o@user_token = JSON.parse(http_post "#{@base_url}/users", {}.to_json, @headers)['token']<Esc>
" Make Status Bar always show at the bottom
set laststatus=2

" Netrw will default to show tree and hide banner
let g:netrw_liststyle = 3
let g:netrw_banner = 0

" To remove esc key lag
set timeoutlen=1000 ttimeoutlen=0

" CtrlP Fuzzy finder stuff
map <Leader>b :CtrlPBuffer<CR>
map <Leader>t :CtrlP<CR>
let g:ctrlp_match_window = 'results:30' " overcome limit imposed by max height

" Set macvim specific stuff
if has("gui_macvim")

  set guifont=Monaco:h10

endif
