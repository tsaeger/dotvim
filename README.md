## About

This vimrc has grown through the years, lifted much of it from others.
Works for me, and it may inspire a setup that works for you.

All scripts/plugins resolve to absolute directory of vimrc.
Meaning this can be used as a portable setup or as your main setup.
One could create many variants and alias to them, or
create a sandboxed vim to test out new plugins.

Notice where the files are sourced in this example:

```
$ vim -u ~/dotvim/vimrc -c scriptnames -c quit
```

The goal is to source all scripts/plugins (except system-wide scripts) from
the same directory as vimrc.


## Quick Start

Clone this repo:
```
$ git clone https://github.com/tsaeger/dotvim.git ~/dotvim
```
Clone Vundle:
```
$ git clone https://github.com/gmarik/Vundle.vim.git ~/dotvim/bundle/Vundle.vim
```
Install Plugins:
```
$ vim -u ~/dotvim/vimrc -c "PluginInstall"
```
Try it out
```
$ vim -u ~/dotvim/vimrc
```
Make it your default
```
$ ln -s ~/dotvim .vim
$ ln -s .vim/vimrc .vimrc
```

## Credits

- Tim Pope's Plugins [https://github.com/tpope](https://github.com/tpope)
- Drew Neil's [vimcasts](http://vimcasts.org/)
- gmarik's Vundle [https://github.com/gmarik/Vundle.vim](https://github.com/gmarik/Vundle.vim)
- [thechangelog episode 0.5.6](http://thechangelog.com/post/4557774334/episode-0-5-6-vim-with-drew-neil-tim-pope-and-yehuda-kat)
- Yan Pritzker's dotfiles [https://github.com/skwp/dotfiles](https://github.com/skwp/dotfiles)
- VimAwesome [http://vimawesome.com/](http://vimawesome.com/)

