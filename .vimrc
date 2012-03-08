"
" Personal preference .vimrc file
" Maintained by Hiroyuki Anai <hiroyuki_anai@yahoo.co.jp>
"

" Use only settings of vim.
set nocompatible

" {{{ vundle settings
filetype off

set rtp+=~/.vim/vundle/
call vundle#rc()

Bundle 'fholgado/minibufexpl.vim'
Bundle 'ZenCoding.vim'
Bundle 'php-doc--su'
Bundle 'javascript.vim'
Bundle 'tpope/vim-rails'
Bundle 'altercation/vim-colors-solarized'
Bundle 'groenewege/vim-less'
Bundle 'othree/html5.vim'

" }}}

" Filetype
filetype plugin indent on

" Highlighting {{{

syntax on
set t_Co=256
"colorscheme wombat256mod
colorscheme solarized
set background=dark

" }}}

" Editing settings {{{
set hidden
set shortmess+=I
set number
set numberwidth=1
set list
set listchars=tab:>-,trail:-,extends:#,nbsp:^,eol:$
set laststatus=2
set cmdheight=1
set showcmd
set title
set scrolloff=2
set statusline=%<%f\ %m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%4v\ %l/%L
set backspace=indent,eol,start

" tabs
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab

" search
set ignorecase
set smartcase
set wrapscan
set nohlsearch
" }}}

"command Tab complement settings {{{
set wildmenu
set wildmode=list:longest
"}}}

" Folding rules {{{

set foldenable
set foldmethod=marker
set foldlevelstart=0
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo

" }}}

" Filetype specific settings {{{
if has("autocmd")

  augroup filetype_detection " {{{

    autocmd BufNewFile,BufRead Gemfile setlocal filetype=ruby

  augroup end " }}}

  augroup invisible_chars "{{{
    au!

    autocmd filetype vim setlocal list
    autocmd filetype ruby setlocal list
    autocmd filetype php setlocal list
    autocmd filetype javascript setlocal list
    autocmd filetype coffee setlocal list
    autocmd filetype css setlocal list
    autocmd filetype html setlocal list
  augroup end " }}}

  augroup ruby_files " {{{
    au!

    autocmd filetype ruby setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
  augroup end " }}}

  augroup javascript_files " {{{
    au!
    autocmd filetype javascript setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
  augroup end " }}}

  augroup coffeescript_files " {{{
    au!
    autocmd filetype coffee setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
  augroup end " }}}

  augroup php_files " {{{
    au!

    autocmd filetype php setlocal foldmethod=marker
    autocmd filetype php setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
  augroup end " }}}

  augroup vim_files " {{{
    au!

    autocmd filetype vim setlocal foldmethod=marker
    autocmd filetype vim setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
  augroup end " }}}

endif
" }}}

" Encoding Settings {{{

set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set fileencodings=iso-2022-jp,utf-8,ucs2le,ucs-2,cp932,euc-jp

" 文字コードの自動認識
" ずんwiki
" http://www.kawaz.jp/pukiwiki/?vim#cb691f26
" {{{
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif

if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているか
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
    " iconvがJISX023に対応しているか
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif

if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif

set fileformats=unix,dos,mac

if exists('&ambiwidth')
  set ambiwidth=double
endif
" }}}

" }}}

" Shortcut mappings {{{
nmap j gj
vmap j gj
nmap k gk
vmap k gk

nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

nmap ,u :set fileformat=unix<CR>
nmap { <c-w><
nmap } <c-w>>

" }}}
"

" command {{{
command! Utf8  :e ++enc=utf-8
command! Eucjp :e ++enc=euc-jp
command! Sjis  :e ++enc=shift-jis
" }}}

" Plugin settings {{{

" minibufexplorer {{{
let g:miniBufExplMapWindowNavVim = 1 
let g:miniBufExplMapWindowNavArrows = 1 
let g:miniBufExplMapCTabSwitchBufs = 1 
let g:miniBufExplModSelTarget = 1 

nmap ,1 :b1<CR>
nmap ,2 :b2<CR>
nmap ,3 :b3<CR>
nmap ,4 :b4<CR>
nmap ,5 :b5<CR>
nmap ,6 :b6<CR>
nmap ,7 :b7<CR>
nmap ,8 :b8<CR>
nmap ,9 :b9<CR>
" }}}

" zencoding.vim {{{

let g:user_zen_settings = {
\  "lang":"ja",
\  "indentation":"    ",
\  "html":{
\    "snippets":{
\      'html:jqm': "<!DOCTYPE HTML>\n"
\                . "<html lang=\"${lang}\">\n"
\                . "<head>\n"
\                . "    <meta charset=\"${charset}\">\n"
\                . "    <title></title>\n"
\                . "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n"
\                . "    <link rel=\"stylesheet\" href=\"http://code.jquery.com/mobile/1.0/jquery.mobile-1.0.min.css\" />\n"
\                . "    <script type=\"text/javascript\" src=\"http://code.jquery.com/jquery-1.6.4.min.js\"></script>\n"
\                . "    <script type=\"text/javascript\" src=\"http://code.jquery.com/mobile/1.0/jquery.mobile-1.0.min.js\"></script>\n"
\                . "</head>\n"
\                . "<body>\n\t${child}|\n</body>\n"
\                . "</html>",
\    },
\    "default_attributes" : {
\      "link:less"   : {"rel": "stylesheet/less", "type": "text/css", "href": "|"},
\      "div:page"    : {"data-role": "page", "data-title": "|"},
\      "div:header"  : {"data-role": "header"},
\      "div:footer"  : {"data-role": "footer"},
\      "div:content" : {"data-role": "content"},
\      "meta:viewport" : {"name": "viewport", "content": "width=device-width, initial-scale=1"},
\      "a:back"      : {"data-rel": "back"},
\      "a:external"  : {"rel": "external"},
\      "a:reverse"   : {"data-direction": "reverse"},
\      "a:dialog": {"data-rel": "dialog"},
\    },
\    "aliases" : {
\      "link:*" : "link",
\      "meta:*" : "meta",
\      "div:*" : "div",
\      "r:pg"  : "div:page",
\      "r:hd"  : "div:header",
\      "r:cnt" : "div:content",
\      "r:ft"  : "div:footer",
\      "l:bk"  : "a:back",
\      "l:ex"  : "a:external",
\      "l:rvs" : "a:reverse",
\      "l:dlg" : "a:dialog",
\
\    },
\  },
\}

" }}}

" }}}

" }}}