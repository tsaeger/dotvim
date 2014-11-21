## About

This vimrc has grown through the years, lifted much of it from others.
Works for me, and it may inspire a setup that works for you.

## Relocatable/Portable vim

The goal is to resolve all scripts/plugins (except system-wide scripts) from
absolute directory of vimrc.

You can use this as a sandboxed vim to test out new plugins.


Notice where the files are sourced in this example:

```
$ vim -u vimrc -c scriptnames -c quit
```


## Quick Start

Clone this repo:
```
$ git clone https://github.com/tsaeger/dotvim.git ~/dotvim
$ cd ~/dotvim
```
Install vim-plug:
```
$ [[ ! -e autoload/plug.vim ]] && curl -fLo autoload/plug.vim \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
Install Plugins:
```
$ vim -u vimrc -c "PlugInstall"
```
Try it out
```
$ vim -u vimrc
```
Make it your default
```
$ ln -s ~/dotvim .vim
$ ln -s .vim/vimrc .vimrc
```
Profile vim startup
```
vim --startuptime vim.out
```

## Credits

- Tim Pope's Plugins [https://github.com/tpope](https://github.com/tpope)
- Drew Neil's [vimcasts](http://vimcasts.org/)
- gmarik's Vundle [https://github.com/gmarik/Vundle.vim](https://github.com/gmarik/Vundle.vim)
- junegunn's vim-plug [https://github.com/junegunn/vim-plug.git](https://github.com/junegunn/vim-plug.git)
- [thechangelog episode 0.5.6](http://thechangelog.com/post/4557774334/episode-0-5-6-vim-with-drew-neil-tim-pope-and-yehuda-kat)
- Yan Pritzker's dotfiles [https://github.com/skwp/dotfiles](https://github.com/skwp/dotfiles)
- VimAwesome [http://vimawesome.com/](http://vimawesome.com/)
