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

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

Plugin 'tpope/vim-fugitive'

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
set autoread
set encoding=utf-8
"set foldmethod=syntax
"set nofoldenable

" Linenumber Stuff
set number
set relativenumber

" Speed up Macros
set lazyredraw

" Set macvim specific stuff
if has("gui_macvim")

  "speciial font
  set guifont=Monaco\ for\ Powerline

  "highlight colors
  highlight Search guifg=NONE
  highlight Search guibg=darkblue

  " colorscheme
  set termguicolors
  highlight LineNr guifg=darkgrey
endif


" Attempt to prevent Netrw from staying open
autocmd FileType netrw setl bufhidden=delete

" Set Tabs to be Better
set ts=2 sts=2 sw=2 expandtab
"
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
"Might help when running from term
if !has('gui_running')
  let g:solarized_termcolors=&t_Co
  let g:solarized_termtrans=1
endif
colorscheme solarized

" airline shit
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

highlight Comment cterm=none
highlight Comment gui=italic

" Color the 88th column
set colorcolumn=88

"----"----"---- Fancy Searching Bullshit "----"----"----

" Set searching to be better
set ignorecase
set smartcase

" used the extensive functions below, stolen from the internets
set incsearch
"annoys me if can't run :noh with esc
if has('gui_running')
  set hlsearch
endif

" STOLEN I AM NO MASTER
" Modified version of Damian Conway's Die Blinkënmatchen: highlight matches
"
" This is how long you want the blinking to last in milliseconds. If you're
" using an earlier Vim without the `+timers` feature, you need a much shorter
" blink time because Vim blocks while it waits for the blink to complete.
let s:blink_length = has("timers") ? 500 : 100

if has("timers")
  " This is the length of each blink in milliseconds. If you just want an
  " interruptible non-blinking highlight, set this to match s:blink_length
  " by uncommenting the line below
  let s:blink_freq = 90
  "let s:blink_freq = s:blink_length
  let s:blink_match_id = 0
  let s:blink_timer_id = 0
  let s:blink_stop_id = 0

  " Toggle the blink highlight. This is called many times repeatedly in order
  " to create the blinking effect.
  function! BlinkToggle(timer_id)
    if s:blink_match_id > 0
      " Clear highlight
      call BlinkClear()
    else
      " Set highlight
      let s:blink_match_id = matchadd('ErrorMsg', s:target_pat, 101)
      redraw
    endif
  endfunction

  " Remove the blink highlight
  function! BlinkClear()
    call matchdelete(s:blink_match_id)
    let s:blink_match_id = 0
    redraw
  endfunction

  " Stop blinking
  "
  " Cancels all the timers and removes the highlight if necessary.
  function! BlinkStop(timer_id)
    " Cancel timers
    if s:blink_timer_id > 0
      call timer_stop(s:blink_timer_id)
      let s:blink_timer_id = 0
    endif
    if s:blink_stop_id > 0
      call timer_stop(s:blink_stop_id)
      let s:blink_stop_id = 0
    endif
    " And clear blink highlight
    if s:blink_match_id > 0
      call BlinkClear()
    endif
  endfunction

  augroup die_blinkmatchen
    autocmd!
    autocmd CursorMoved * call BlinkStop(0)
    autocmd InsertEnter * call BlinkStop(0)
  augroup END
endif

function! HLNext(blink_length, blink_freq)
  let s:target_pat = '\c\%#'.@/
  if has("timers")
    " Reset any existing blinks
    call BlinkStop(0)
    " Start blinking. It is necessary to call this now so that the match is
    " highlighted initially (in case of large values of a:blink_freq)
    call BlinkToggle(0)
    " Set up blink timers.
    let s:blink_timer_id = timer_start(a:blink_freq, 'BlinkToggle', {'repeat': -1})
    let s:blink_stop_id = timer_start(a:blink_length, 'BlinkStop')
  else
    " Vim doesn't have the +timers feature. Just use Conway's original
    " code.
    " Highlight the match
    let ring = matchadd('ErrorMsg', s:target_pat, 101)
    redraw
    " Wait
    exec 'sleep ' . a:blink_length . 'm'
    " Remove the highlight
    call matchdelete(ring)
    redraw
  endif
endfunction

" Only going to use all that fanciness if in a gui
if has('gui_running')
  nnoremap <Esc> :noh<CR>
  " Set up maps for n and N that blink the match
  execute printf("nnoremap <silent> n n:call HLNext(%d, %d)<cr>", s:blink_length, has("timers") ? s:blink_freq : s:blink_length)
  execute printf("nnoremap <silent> N N:call HLNext(%d, %d)<cr>", s:blink_length, has("timers") ? s:blink_freq : s:blink_length)
endif


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


" LEADER MAPPINGS
" set mapleader
let mapleader = "\<Space>"

" General Use Commands
" set save
nmap <Leader>s :w<CR>
vmap <Leader>s :w<CR>

" I open vimrc a lot
nmap <Leader>vrc :e ~/.vimrc<CR>

" set copy/paste - not needed in macvim
vmap <Leader>y :w !pbcopy<CR>
"nmap <Leader>p :r !pbpaste<CR>

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

" Testing Specific Commands
" Add or Remove Test Tag at top of File and Write to File
nmap <Leader>tes gg/<Space>do<CR>i,<Space>test:true<Space><Esc>:w<CR>
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

" Ignore big unneccesary directories
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.yardoc\|node_modules\|log\|tmp$',
  \ 'file': '\.so$\|\.dat$|\.DS_Store$'
  \ }

