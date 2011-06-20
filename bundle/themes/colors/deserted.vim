" Vim color file
" Maintainer:           Jon Nalley <jon@nalleynet.com>
" Based On Desert By:   Hans Fugal <hans@fugal.net>
" Last Change:          $Date: 2003/07/24 00:57:11 $
" URL:                  http://nalleynet.com/~jnalley/vim/colors/deserted.vim
" Version:              $Id: desert.vim,v 1.7 2003/07/24 00:57:11 fugalh Exp $

" cool help screens
" :he group-name
" :he highlight-groups
" :he cterm-colors

set background=dark
hi clear
if exists("syntax_on")
	syntax reset
endif

let colors_name = "deserted"

" color terminal definitions
hi SpecialKey   ctermfg=darkgreen
hi NonText      cterm=bold ctermfg=darkblue
hi Directory    ctermfg=darkcyan
hi ErrorMsg     cterm=bold ctermfg=7 ctermbg=1
hi MoreMsg      ctermfg=darkgreen
hi ModeMsg      cterm=NONE ctermfg=brown
hi LineNr       ctermfg=3
hi Question     ctermfg=green
hi StatusLine   cterm=bold,reverse
hi StatusLineNC cterm=reverse
hi Title        ctermfg=5
hi Visual       cterm=reverse
hi VisualNOS    cterm=bold,underline
hi WarningMsg   ctermfg=1
hi WildMenu     ctermfg=0 ctermbg=3
hi Folded       ctermfg=darkgrey ctermbg=NONE
hi FoldColumn   ctermfg=darkgrey ctermbg=NONE
hi DiffAdd      ctermfg=DarkCyan
hi DiffChange   ctermfg=Yellow
hi DiffDelete   ctermfg=DarkMagenta
hi DiffText     ctermfg=DarkCyan
hi Special      ctermfg=5
hi Underlined   cterm=underline ctermfg=5
hi Ignore       cterm=bold ctermfg=7
hi Ignore       ctermfg=darkgrey
hi Error        cterm=bold ctermfg=7 ctermbg=1
hi MatchParen   ctermfg=White ctermbg=Black

highlight Normal        ctermfg=Gray  ctermbg=NONE cterm=NONE

highlight IncSearch     ctermfg=DarkBlue ctermbg=White
highlight Search        ctermfg=Yellow ctermbg=Cyan

highlight Comment       ctermfg=Blue

highlight Constant      ctermfg=Yellow
hi        String        ctermfg=DarkCyan
hi        Character     ctermfg=Red
hi        Number        ctermfg=DarkRed
hi        Float         ctermfg=Green
hi        Boolean       ctermfg=Magenta

highlight Identifier    ctermfg=Cyan
hi        Function      ctermfg=White

highlight Statement     ctermfg=Brown
hi        Conditional   ctermfg=Red
hi        Repeat        ctermfg=Brown
hi        Label         ctermfg=White
hi        Operator      ctermfg=Brown
hi        Keyword       ctermfg=Brown
hi        Exception     ctermfg=Brown

highlight PreProc       ctermfg=DarkRed
hi        Include       ctermfg=DarkRed
hi        Define        ctermfg=DarkRed

highlight Type          ctermfg=DarkGreen
hi        StorageClass  ctermfg=Yellow
hi        Structure     ctermfg=Yellow
hi        Typedef       ctermfg=Yellow

"vim: sw=4
