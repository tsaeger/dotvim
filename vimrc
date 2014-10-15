" Relocatable vim {{{1
" > vim -u THISDIR/vimrc
"==================================================
" set initial runtimepath, excluding ~/.vim
let &runtimepath = printf('%s/vimfiles,%s,%s/vimfiles/after', $VIM, $VIMRUNTIME, $VIM)

" use resolve to expand symlinks to make the following work:
" > ln -s ~/dotvim .vim
" > ln -s .vim/vimrc .vimrc
let s:vimpath    = fnamemodify(resolve(expand('<sfile>')), ':p:h')      " directory of this file
let s:vimrc      = resolve(expand('<sfile>'))                           " vimrc
let s:backupdir  = fnameescape(join([s:vimpath,'/backups'], ''))        " backups
let s:pluginpath = fnameescape(join([s:vimpath,'/bundle'],''))          " plugins
let s:vundlepath = fnameescape(join([s:pluginpath,'/Vundle.vim'],''))   " Vundle path
let s:settings   = fnameescape(join([s:vimpath,'/settings.vim'],''))    " settings file

" echo s:vimrc
" echo s:vimpath
" echo s:backupdir
" echo s:pluginpath
" echo s:vundlepath
" echo s:settings

" add dirs to runtimepath
let &runtimepath = printf('%s,%s,%s/after,%s', s:vimpath, &runtimepath, s:vimpath, s:vundlepath)

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
set t_Co=256
syntax on

" leader key
" let mapleader='\'
"===============================================}}}
" Plugins {{{1
"==================================================
call vundle#begin(s:pluginpath)

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'airblade/vim-gitgutter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'bling/vim-airline'
Plugin 'bronson/vim-visual-star-search'
Plugin 'csexton/trailertrash.vim'
Plugin 'edkolev/tmuxline.vim'
Plugin 'flazz/vim-colorschemes'
Plugin 'godlygeek/tabular'
Plugin 'gregsexton/gitv'
Plugin 'henrik/vim-qargs'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'joeytwiddle/vim-multiple-cursors'
Plugin 'justinmk/vim-sneak'
Plugin 'marijnh/tern_for_vim'
Plugin 'mileszs/ack.vim'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'nelstrom/vim-mac-classic-theme'
Plugin 'rking/ag.vim'
Plugin 'scrooloose/syntastic'
Plugin 'sheerun/vim-polyglot'
Plugin 'Shougo/neomru.vim'
Plugin 'Shougo/unite-outline'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/vimfiler.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'SirVer/ultisnips'
Plugin 'sjl/gundo.vim'
Plugin 'tacroe/unite-mark'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-obsession'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-vividchalk'
Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-scripts/DirDiff.vim'
Plugin 'vim-scripts/DrawIt'
Plugin 'vim-scripts/editorconfig-vim'
Plugin 'vim-scripts/taglist.vim'

" Personal/Private plugins
Plugin 'git@github.com:tsaeger/vim-snippets'
" Plugin 'tsaeger/vim-snippets'

" Not currently used
" Plugin 'ervandew/supertab'
" Plugin 'kchmck/vim-coffee-script'
" Plugin 'kergoth/vim-bitbake'
" Plugin 'kien/ctrlp.vim'
" Plugin 'Lokaltog/vim-easymotion'
" Plugin 'scrooloose/nerdtree'
" Plugin 'tpope/vim-pathogen'
" Plugin 'vim-scripts/cream-showinvisibles'
" Plugin 'vim-scripts/localvimrc'
" Plugin 'vim-scripts/PKGBUILD'
" Plugin 'vim-scripts/taglist-plus'
" Plugin 'vim-scripts/YankRing.vim'


" Plugins must be added before here
call vundle#end()
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
set ts=4 sw=4 sts=4 et
" set ts=8 sw=8 sts=8 noet
noremap <leader>ne :set ts=4 sw=4 sts=4 et<cr>
noremap <leader>ke :set ts=8 sw=8 sts=8 noet<cr>

filetype plugin on
filetype indent on

set listchars=tab:▸\ ,eol:¬
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
execute "source " . s:settings
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
