" Relocatable vim {{{1
" > vim -u THISDIR/vimrc
"==================================================
" set initial runtimepath, excluding ~/.vim
let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)

" use resolve() to expand symlinks to make the following work:
" > ln -s ~/dotvim .vim
" > ln -s .vim/vimrc .vimrc
let s:vimpath    = fnamemodify(resolve(expand('<sfile>')), ':p:h')      " directory of this file
let s:vimrc      = resolve(expand('<sfile>'))                           " vimrc
let s:backupdir  = fnameescape(join([s:vimpath,'/backups'],''))         " backups
let s:pluginpath = fnameescape(join([s:vimpath,'/plugged'],''))         " plugins
let s:settings   = fnameescape(join([s:vimpath,'/settings.vim'],''))    " settings file

" echo s:vimrc
" echo s:vimpath
" echo s:backupdir
" echo s:pluginpath
" echo s:settings

" add dirs to runtimepath
let &runtimepath = printf('%s,%s,%s/after', s:vimpath, &runtimepath, s:vimpath)

" echo &runtimepath

set nocompatible
filetype off
"===============================================}}}
" General config {{{1
"==================================================
set autoread
set backspace=eol,start,indent
" set clipboard=unnamed
set ffs=unix,dos,mac
set hidden
set history=1000
set ignorecase smartcase incsearch
" set lazyredraw
set mouse=a
" set number
set ruler
set shell=zsh
set showcmd
set showmode
set visualbell
set t_Co=256  " for airline/tmuxline
syntax on

" leader key
" let mapleader='\'
"===============================================}}}
" Plugins {{{1
"==================================================
call plug#begin(s:pluginpath)

Plug 'airblade/vim-gitgutter'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bronson/vim-visual-star-search'
Plug 'chriskempson/base16-vim'
Plug 'csexton/trailertrash.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'edkolev/tmuxline.vim'
Plug 'flazz/vim-colorschemes'
Plug 'godlygeek/tabular'
Plug 'gregsexton/gitv'
Plug 'henrik/vim-qargs'
Plug 'jlanzarotta/bufexplorer'
Plug 'joeytwiddle/vim-multiple-cursors'
Plug 'justinmk/vim-sneak'
Plug 'marijnh/tern_for_vim'
Plug 'mileszs/ack.vim'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'nelstrom/vim-mac-classic-theme'
Plug 'rking/ag.vim'
Plug 'scrooloose/syntastic'
Plug 'sheerun/vim-polyglot'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/unite-outline'
Plug 'Shougo/unite.vim'
Plug 'Shougo/vimfiler.vim'
Plug 'Shougo/vimproc.vim' , { 'do': 'make -f make_unix.mak' }
" Plug 'SirVer/ultisnips'
Plug 'sjl/gundo.vim'
Plug 'tacroe/unite-mark'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vividchalk'
Plug 'tmatilai/gitolite.vim'
" Plug 'Valloric/YouCompleteMe' , { 'do': './install.py' }
" Plug 'Valloric/YouCompleteMe' , { 'do': './install.py --clang-completer' }
Plug 'vim-scripts/DirDiff.vim'
Plug 'vim-scripts/DrawIt'
Plug 'vim-scripts/taglist.vim'
Plug 'vivien/vim-linux-coding-style'

" Personal/Private plugins
" Plug 'git@github.com:tsaeger/vim-snippets'
Plug 'tsaeger/vim-snippets'

" Not currently used
" Plug 'kchmck/vim-coffee-script'
" Plug 'kergoth/vim-bitbake'
" Plug 'Lokaltog/vim-easymotion'
" Plug 'vim-scripts/localvimrc'
" Plug 'vim-scripts/PKGBUILD'
" Plug 'vim-scripts/taglist-plus'


" Plugins must be added before here
call plug#end()
"===============================================}}}
" Completion {{{1
"==================================================
set wildmode=list:longest
set wildmenu
set wildignore+=*.o,*.obj,*.a
set wildignore+=*.pyc
set wildignore+=*~,*.bak
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
set wildignore+=tmp/**
"===============================================}}}
" Editing {{{1
"==================================================
set autoindent
set smartindent
set smarttab
set nowrap
set linebreak
" set ts=4 sw=4 sts=4 et
set ts=8 sw=8 sts=8 noet
noremap <leader>ne :set ts=4 sw=4 sts=4 et<cr>
noremap <leader>ke :set ts=8 sw=8 sts=8 noet<cr>

filetype plugin on
filetype indent on

set listchars=tab:<>,eol:$
if has('multi_byte')
set listchars=tab:▸\ ,eol:¬
endif
"Example listchars
"			Tabbed example

"===============================================}}}
" Folding {{{1
"==================================================
" set foldmethod=indent
" set foldmethod=syntax
set nofoldenable
" set foldenable
"===============================================}}}
" Scrolling {{{1
"==================================================
set scrolloff=8
"===============================================}}}
" Swap files {{{1
"==================================================
set noswapfile
set nobackup
" set nowritebackup
"===============================================}}}
" Undo persistence {{{1
"==================================================
if has('persistent_undo')
    silent execute "!mkdir " . s:backupdir . "> /dev/null 2>&1"
    execute "set undodir=" . s:backupdir
    set undofile
endif
"===============================================}}}
" Settings files {{{1
"==================================================
" source all /settings/*.vim files
let s:settingspath = fnameescape(join([s:vimpath,'/settings'], ''))  " settings
" echo "settingspath:" . s:settingspath
for fpath in split(globpath(s:settingspath, '*.vim'), '\n')
  " echo "sourcing:" . fpath
  execute "source" fpath
endfor
"===============================================}}}
" vimrc management {{{1
"==================================================
" Fast reloading of the .vimrc
execute "noremap <leader>s :source " . s:vimrc . "<cr>"
" Fast editing of .vimrc
execute "noremap <leader>e :e! " . s:vimrc . "<cr>"
execute "noremap <leader><leader>e :e! " . s:settings . "<cr>"
" Reload .vimrc when written
execute "autocmd! bufwritepost " . s:vimrc . " source " . s:vimrc
"===============================================}}}
" vim:ft=vim:ts=4:sw=4:et:fdm=marker:commentstring=\"\ %s:nowrap
