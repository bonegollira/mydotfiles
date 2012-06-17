"
" Personal preference .vimrc file
" Maintained by Hiroyuki Anai <hiroyuki_anai@yahoo.co.jp>
"

" Use only settings of vim.
set nocompatible

let s:iswin = has('win32') || has('win64')

" Use English interface.
if s:iswin
  " For Windows.
  language message en
  let $MYVIMDIR = expand('~/vimfiles')
else
  " For Linux.
  language mes C
  let $MYVIMDIR = expand('~/.vim')
endif

if s:iswin
  " Exchange path separator.
  set shellslash
endif

" {{{ Vundle settings

filetype off

set rtp+=~/.vim/vundle.git/
call vundle#rc()

Bundle 'fholgado/minibufexpl.vim'
Bundle 'ZenCoding.vim'
Bundle 'php-doc--su'
Bundle 'javascript.vim'
Bundle 'tpope/vim-rails'
Bundle 'altercation/vim-colors-solarized'
Bundle 'groenewege/vim-less'
Bundle 'othree/html5.vim'
Bundle 'scrooloose/nerdtree'

" }}}

filetype plugin on
filetype indent on

" Options {{{

" indent
set autoindent
set smartindent
set expandtab
set smarttab
set tabstop=4

" search
set hlsearch
set smartcase

" listchars
set list
set listchars=tab:>_,extends:>,precedes:<,eol:$

" shift
set shiftround
set shiftwidth=4

" completion
set complete=.,w,b,u,t,i,d,k,kspell
set wildmenu
set wildmode=list:longest
set pumheight=20

" swap
set swapfile
set directory-=.

" scroll
set scrolloff=2

" fsync() is slow...
if has('unix')
  set nofsync
  set swapsync=
endif

" backup
set backup
let &backupdir = $MYVIMDIR . '/backup'
if !isdirectory(&backupdir)
  call mkdir(&backupdir, 'p')
endif

function! SandboxCallOptionFn(option_name) "{{{
  try
    return s:{a:option_name}()
  catch
    call setbufvar('%', '&' . a:option_name, '')
    return ''
  endtry
endfunction "}}}

" title
set title
function! s:titlestring() "{{{
  if exists('t:cwd')
    return t:cwd . ' (tab)'
  elseif haslocaldir()
    return getcwd() . ' (local)'
  else
    return getcwd()
  endif
endfunction "}}}
let &titlestring = '%{SandboxCallOptionFn("titlestring")}'

" statusline
set laststatus=2
set statusline=%<%f\ %m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%4v\ %l/%L

" syntax
syntax on
set t_Co=256
colorscheme wombat256mod
"colorscheme solarized

" number
set number
set numberwidth=1

set hidden
set shortmess+=I
set laststatus=2
set cmdheight=1
set showcmd
set backspace=indent,start

" fold
set foldenable
set foldmethod=marker
set foldlevelstart=0
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo

" encoding
set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8
set fileencodings=iso-2022-jp,utf-8,ucs2le,ucs-2,cp932,euc-jp

" fileformats
set fileformats=unix,dos,mac

" }}}

" Autocmd {{{

function! s:set_short_indent()  "{{{
  setlocal expandtab softtabstop=2 shiftwidth=2
endfunction " }}}

augroup MyAutoCmd
  autocmd!
augroup END

" Filetype detection
autocmd MyAutoCmd BufNewFile,BufRead Gemfile*   setlocal filetype=ruby
autocmd MyAutoCmd BufNewFile,BufRead Guardfile  setlocal filetype=ruby
autocmd MyAutoCmd BufNewFile,BufRead *.coffee   setlocal filetype=coffee
autocmd MyAutoCmd BufNewFile,BufRead *.sass     setlocal filetype=sass
autocmd MyAutoCmd BufNewFile,BufRead *.less     setlocal filetype=less

" Short indent
autocmd MyAutoCmd filetype ruby       call s:set_short_indent()
autocmd MyAutoCmd filetype vim        call s:set_short_indent()
autocmd MyAutoCmd filetype coffee     call s:set_short_indent()
autocmd MyAutoCmd filetype html       call s:set_short_indent()
autocmd MyAutoCmd filetype sass       call s:set_short_indent()
autocmd MyAutoCmd filetype less       call s:set_short_indent()
autocmd MyAutoCmd filetype javascript call s:set_short_indent()

" }}}

" Encoding detection http://www.kawaz.jp/pukiwiki/?vim#cb691f26 {{{
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

function! AU_ReCheck_FENC()
  if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
    let &fileencoding=&encoding
  endif
endfunction
autocmd MyAutoCmd BufReadPost * call AU_ReCheck_FENC()

if exists('&ambiwidth')
  set ambiwidth=double
endif
" }}}

" Shortcut mappings {{{

" :nohlsearch
nnoremap <ESC><ESC> :nohlsearch<CR>

noremap j gj
noremap k gk

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

" Reopen with other encoding {{{

command! Utf8  :e ++enc=utf-8
command! Eucjp :e ++enc=euc-jp
command! Sjis  :e ++enc=shift-jis

" }}}

" Plugin settings {{{
"
" php-doc.vim
inoremap <C-P> <ESC>:call PhpDocSingle()<CR>i
nnoremap <C-P> :call PhpDocSingle()<CR>
vnoremap <C-P> :call PhpDocRange()<CR>

" minibufexplorer.vim
let g:miniBufExplMapWindowNavVim = 1 
let g:miniBufExplMapWindowNavArrows = 1 
let g:miniBufExplMapCTabSwitchBufs = 1 
let g:miniBufExplModSelTarget = 1 

nnoremap ,1 :b1<CR>
nnoremap ,2 :b2<CR>
nnoremap ,3 :b3<CR>
nnoremap ,4 :b4<CR>
nnoremap ,5 :b5<CR>
nnoremap ,6 :b6<CR>
nnoremap ,7 :b7<CR>
nnoremap ,8 :b8<CR>
nnoremap ,9 :b9<CR>

" zencoding.vim
let g:user_zen_settings = {
\  "lang":"ja",
\  "indentation":"  ",
\  "html":{
\    "snippets":{
\      'html:jqm': "<!DOCTYPE HTML>\n"
\                . "<html lang=\"${lang}\">\n"
\                . "<head>\n"
\                . "  <meta charset=\"${charset}\">\n"
\                . "  <title></title>\n"
\                . "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n"
\                . "  <link rel=\"stylesheet\" href=\"http://code.jquery.com/mobile/1.0/jquery.mobile-1.0.min.css\" />\n"
\                . "  <script type=\"text/javascript\" src=\"http://code.jquery.com/jquery-1.6.4.min.js\"></script>\n"
\                . "  <script type=\"text/javascript\" src=\"http://code.jquery.com/mobile/1.0/jquery.mobile-1.0.min.js\"></script>\n"
\                . "</head>\n"
\                . "<body>\n\t${child}|\n</body>\n"
\                . "</html>",
\    },
\    "default_attributes" : {
\      "link:less"   : {"rel": "stylesheet/less", "type": "text/css", "href": "|"},
\      "script:yui"  : {"type": "text/javascript", "src": "http://yui.yahooapis.com/3.4.1/build/yui/yui-min.js"},
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
\  "eruby":{
\    "snippets":{
\      'erb': "<%= ${child}| %>",
\    },
\  },
\}

" }}}
