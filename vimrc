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
let s:settingspath = fnameescape(join([s:vimpath,'/settings'], ''))     " settings

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

" nixpkgs vim-plugins
" for p in ["youcompleteme"] | exec 'set rtp+=~/.nix-profile/share/vim-plugins/'.p | endfor
for p in ["fzf"] | exec 'set rtp+=~/.nix-profile/share/vim-plugins/'.p | endfor

call plug#begin(s:pluginpath)

" Vim workflows
Plug 'airblade/vim-gitgutter'
Plug 'bronson/vim-visual-star-search'
Plug 'chrisbra/nrrwrgn'
Plug 'chrisbra/vim-diff-enhanced'
Plug 'csexton/trailertrash.vim'
Plug 'francoiscabrol/ranger.vim'
Plug 'godlygeek/tabular'
Plug 'gregsexton/gitv'
Plug 'henrik/vim-qargs'
Plug 'igemnace/vim-makery'
Plug 'jlanzarotta/bufexplorer'
Plug 'joeytwiddle/vim-multiple-cursors'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/gv.vim'
Plug 'justinmk/vim-sneak'
Plug 'kablamo/vim-git-log'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'sjl/gundo.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-vividchalk'
Plug 'vim-scripts/DirDiff.vim'
Plug 'vim-scripts/DrawIt'
Plug 'vim-scripts/git_patch_tags.vim'
Plug 'vim-scripts/taglist.vim'
Plug 'vivien/vim-linux-coding-style'

" Finders
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Plug 'lotabout/skim.vim'
" Plug 'mileszs/ack.vim'
" Plug 'rking/ag.vim'
" Plug 'jremmen/vim-ripgrep'


" Colors
Plug 'altercation/vim-colors-solarized'
Plug 'chriskempson/base16-vim'
Plug 'flazz/vim-colorschemes'
Plug 'edkolev/tmuxline.vim'
Plug 'nelstrom/vim-mac-classic-theme'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Language/formatting/syntax
Plug 'fatih/vim-go'
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }
Plug 'editorconfig/editorconfig-vim'
Plug 'sheerun/vim-polyglot'
Plug 'SirVer/ultisnips'
Plug 'vim-syntastic/syntastic'

" Completion system
"" Plug 'osyo-manga/unite-quickfix'
"" Plug 'Shougo/neomru.vim'
"" Plug 'Shougo/neoyank.vim'
"" Plug 'Shougo/unite-outline'
"" Plug 'Shougo/unite.vim'
"" Plug 'tacroe/unite-mark'
"" Plug 'Shougo/vimfiler.vim'
"" Plug 'vim-scripts/vim-unite-cscope'
"" Plug 'Shougo/vimproc.vim' , { 'do': 'make -f make_unix.mak' }
"" " Plug 'Valloric/YouCompleteMe' , { 'do': './install.py' }
"" " Plug 'Valloric/YouCompleteMe' , { 'do': './install.py --clang-completer' }

Plug 'neoclide/coc.nvim', {'branch': 'release'}


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
" Plug 'marijnh/tern_for_vim'
" Plug 'tmatilai/gitolite.vim'


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
" Reload .vimrc when written
execute "autocmd! bufwritepost " . s:vimrc . " source " . s:vimrc
"===============================================}}}
" vim:ft=vim:ts=4:sw=4:et:fdm=marker:commentstring=\"\ %s:nowrap
