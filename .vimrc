" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" ========== Vundle ==========
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'bling/vim-airline'

" All of your Plugins must be added before the following line
call vundle#end()            " required

" ========== General Config ==========

set encoding=utf-8

set number                      "Line numbers
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store history
set showcmd                     "Show incomplete cmds
set showmode                    "Show current mode
set gcr=a:blinkon0              "disable cursor blank
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim
set mouse=a                     "Use mouse
set ruler                       "show the cursor position all the time
set incsearch                   "do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq

" buffers can exist in the background without being in a window
set hidden

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif

" ========== Vundle ==========
if filereadable(expand("~/.vim/vundles.vim"))
  source ~/.vim/vundles.vim
endif

" ========== Turn off swap files ==========

set noswapfile
set nobackup
set nowb

" ========== Indentation ==========

set autoindent
set smartindent
set smarttab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

filetype plugin on
filetype indent on

set list listchars=tab:\ \ ,trail:·

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ========== Folds ==========

set foldmethod=indent
set foldnestmax=3
set nofoldenable

" ========== Scrolling ==========

set scrolloff=8
set sidescrolloff=15
set sidescroll=1

syntax enable
set background=dark
colorscheme solarized

" ========== Airline ==========

set laststatus=2
let g:airline_powerline_fonts=1
