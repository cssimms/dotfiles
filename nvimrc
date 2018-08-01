set nocompatible

"set runtimepath^=~/.vim/bundle/ctrlp.vim

"____"____"____ PLUG TO MANAGE PLUGINS "____"____"____

call plug#begin('~/.local/share/nvim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-fugitive'

Plug 'Yggdroot/indentLine'

Plug 'tpope/vim-surround'

Plug 'altercation/vim-colors-solarized'
Plug 'chriskempson/base16-vim'

call plug#end()            " required

"____"____"____ GENERAL SETTINGS "____"____"____

syntax on
set autoread
set encoding=utf-8
" Last I checked folding caused significant slowdown - will debug later
"set foldmethod=syntax
"set nofoldenable

" Linenumber Stuff
set number
set relativenumber

" Speed up Macros
set lazyredraw

" Attempt to prevent Netrw from staying open
autocmd FileType netrw setl bufhidden=delete

" Set Tabs to be Better
" default is two
set ts=2 sts=2 sw=2 expandtab

" python and js are four
autocmd Filetype python setlocal ts=4 sw=4 sts=4 noexpandtab
"autocmd Filetype javascript setlocal ts=4 sw=4 sts=4 noexpandtab

" IndentLine
let g:indentLine_char = '|'
let g:indentLine_first_char = '|'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_setColors = 1

" Make Backspace not Stupid
set backspace=indent,eol,start

" Color Scheme Setup
syntax enable
set t_Co=256
set background=dark
"colorscheme solarized
colorscheme base16-default-dark

let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" airline shit
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

highlight Comment cterm=none
highlight Comment gui=italic

" Color the 88th column
set colorcolumn=88

" Make Status Bar always show at the bottom
set laststatus=2

" Netrw will default to show tree and hide banner
let g:netrw_liststyle = 3
let g:netrw_banner = 0

" To remove esc key lag
set timeoutlen=1000 ttimeoutlen=0

" NeoVim's Mouse scrolling and selection support
set mouse=a

"----"----"---- Fancy Searching Bullshit "----"----"----

" Set searching to be better
set ignorecase
set smartcase
set nohlsearch

"----"----"---- Auto Completion "----"----"----
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

"____"____"____ LEADER MAPPINGS "____"____"____
" set mapleader
let mapleader = "\<Space>"

" General Use Commands
" set save
nmap <Leader>s :w<CR>
vmap <Leader>s :w<CR>

" I open vimrc a lot
nmap <Leader>vrc :e ~/.nvimrc<CR>

" set copy/paste
"vmap <Leader>y :w !pbcopy<CR>
"nmap <Leader>p :r !pbpaste<CR>
vnoremap  <Leader>y  "+y
nnoremap  <Leader>Y  "+yg_
nnoremap  <Leader>y  "+y

" Comment out in Ruby
" sometime later will write a function to handle filetypes
nmap <Leader>/ <S-v>:norm ^i#<CR>
vmap <Leader>/ :norm ^i#<CR>

" Window Splitting and Nav
set splitbelow
set splitright
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
inoremap <C-J> <Esc><C-W><C-J>
inoremap <C-K> <Esc><C-W><C-K>
inoremap <C-L> <Esc><C-W><C-L>
inoremap <C-H> <Esc><C-W><C-H>

" close window faster
nnoremap <Leader>q :q<CR>

" Buffer Nav
nmap <Leader>ls :ls<CR>:
nmap <Leader>] :bn<CR>
nmap <Leader>[ :bp<CR>
nmap <Leader>\ <C-^>

"____"____"____ Interactive Terminal Mode

" Open terminal buffer vert split
nnoremap <Leader>z :vsplit<CR>:terminal<CR>isource ~/.bash_profile<CR>

nmap <Leader>tr :terminal<CR>

" Make escape not stupid in Terminal Mode
tnoremap <Esc> <C-\><C-n>

" Switch windows quickly
tnoremap <C-J> <Esc><C-W><C-J>
tnoremap <C-K> <Esc><C-W><C-K>
tnoremap <C-L> <Esc><C-W><C-L>
tnoremap <C-H> <Esc><C-W><C-H>

" From StackOverflow - with my own regex to include tabs
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

" Rspec (Testing) Specific Commands
" Add or Remove Test Tag at top of File and Write to File
" Test Right Here - goes to inner-most context block and inserts test tag
nmap <Leader>tes gg/<Space>do<CR>i,<Space>test:true<Esc>:w<CR>
nmap <Leader>trh ?context<Space><CR>/<Space>do<CR>i,<Space>test:true<Esc>:w<CR>
nmap <Leader>rtes gg/,<Space>test:<CR>4cw<Esc>:w<CR>

" Insert or remove binding.prty
nmap <Leader>d obinding.pry<Esc>:w<CR>
nmap <Leader>rd /binding<CR>dd:w<CR>

" Boiler Plate Config
nmap <Leader>url o@base_url = Config.base_url<CR>@headers = Config.headers<Esc>

" Snippet for response and data from http request
nmap <Leader>post oresponse = http_post "#{@base_url}/", body, @headers<CR>data = JSON.parse response<Esc>k^f/
nmap <Leader>get oresponse = http_get "#{@base_url}/", @headers<CR>data = JSON.parse response<Esc>k^f/

" Post an empty user
nmap <Leader>use o@user_token = JSON.parse(http_post "#{@base_url}/users", {}.to_json, @headers)['token']<Esc>



" WAM Web Dev Commands

" js if snippet
nmap <Leader>if oif () {<CR>};<Esc>kf(


" CtrlP Fuzzy finder stuff
"map <C-b> :CtrlPBuffer<CR>
"map <Leader>t :CtrlP<CR>
"map <Leader>f :CtrlPLine<CR>
"let g:ctrlp_match_window = 'results:30' " overcome limit imposed by max height

" Ignore big unneccesary directories
"let g:ctrlp_custom_ignore = {
  "\ 'dir':  '\.git$\|\.yardoc\|node_modules\|log\|tmp$',
  "\ 'file': '\.so$\|\.dat$|\.DS_Store$'
  "\ }

" Trying out FZF Fuzzy finder stuff
map <C-p> :Files ./<CR>
map <C-b> :Buffers<CR>
map <C-f> :Ag 

" general fzf colors, doesn't apply to Ag 
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Keyword'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Change the color output of the filepaths, and use the fzf preview <3
" Stolen from Github
" https://github.com/junegunn/fzf.vim/issues/394
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, '--color-path "1;36"', fzf#vim#with_preview(), <bang>0)

