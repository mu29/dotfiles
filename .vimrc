" this must be first
set encoding=utf-8
set nocompatible

" =============== Vundle ===============
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'The-NERD-Tree'
Plugin 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}

call vundle#end()            " required
filetype plugin indent on    " required

" =============== CtrlP ================
set runtimepath^=~/.vim/bundle/ctrlp.vim
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " Linux/MacOSX
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'

" =============== Syntax ===============
syntax on
colorscheme Tomorrow-Night

" =============== Inent ===============
set autoindent                " set auto indent
set smartindent
set ts=2                      " set indent to 2 spaces
set shiftwidth=2
set expandtab                 " use spaces instead of tabs
set smarttab

" Auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

set nowrap
set linebreak

" =============== Search ===============
set ignorecase                " ignore case in search
set hlsearch                  " highlight all search matches

" =============== Scroll ===============
set scrolloff=8
set sidescrolloff=15
set sidescroll=1

" =============== General Config ===============
set vb                        " enable visual bell
set ruler
set showmatch                 " show bracket matches
set clipboard=unnamed         " use system clipboard
set number                    " line numbers
set history=1000              " store history
set autoread                  " reload files changed outside vim
set mouse=a                   " use mouse
set background=dark
set cursorline

" =============== Custom Colors ===============
highlight clear SignColumn
highlight VertSplit    ctermbg=236
highlight ColorColumn  ctermbg=237
highlight LineNr       ctermbg=236 ctermfg=240
highlight CursorLineNr ctermbg=236 ctermfg=240
highlight CursorLine   ctermbg=236 cterm=none
highlight StatusLineNC ctermbg=238 ctermfg=0
highlight StatusLine   ctermbg=240 ctermfg=12
highlight IncSearch    ctermbg=3   ctermfg=1
highlight Search       ctermbg=1   ctermfg=3
highlight Visual       ctermbg=3   ctermfg=0
highlight Pmenu        ctermbg=240 ctermfg=12
highlight PmenuSel     ctermbg=3   ctermfg=1
highlight SpellBad     ctermbg=0   ctermfg=1

