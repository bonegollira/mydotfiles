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

" {{{ NeoBundle settings

filetype off

" for golang
" http://mattn.kaoriya.net/software/vim/20130531000559.htm
if $GOROOT != ''
  set rtp+=$GOROOT/misc/vim
  exe "set rtp+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim", "src/github.com/golang/lint/misc/vim")
endif


if has('vim_starting')
  set rtp+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

NeoBundle 'mattn/emmet-vim'
NeoBundle 'vexxor/phpdoc.vim'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'tpope/vim-rails'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'groenewege/vim-less'
NeoBundle 'othree/html5.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'tomasr/molokai'
NeoBundle 'leafgarland/typescript-vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'thinca/vim-unite-history'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'honza/snipmate-snippets'
NeoBundle 'mattn/webapi-vim'
NeoBundle 'mattn/gist-vim'
NeoBundle 'leafgarland/typescript-vim'
NeoBundle 'vim-scripts/sudo.vim'
NeoBundle 'Blackrush/vim-gocode'
NeoBundle 'akiomik/git-gutter-vim'
NeoBundle 'briancollins/vim-jst'
NeoBundle 'nono/vim-handlebars'
NeoBundle 'matchit.zip'
NeoBundle 'ekalinin/Dockerfile.vim'

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
set nohlsearch
set smartcase

" listchars
set list
set listchars=tab:^_,trail:-,extends:>,precedes:<,eol:$

" shift
set shiftround
set shiftwidth=4

" completion
set complete=.,w,b,u,t,i,d,k,kspell
set completeopt=menu,preview
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

" reload automatically if file has changed
set autoread

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
colorscheme molokai

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

" enable modeline
set modeline

" }}}

" Autocmd {{{

function! s:set_short_indent()  "{{{
  setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
endfunction " }}}

augroup MyAutoCmd
  autocmd!
augroup END

" Filetype detection
autocmd MyAutoCmd BufNewFile,BufRead Gemfile*     setlocal filetype=ruby
autocmd MyAutoCmd BufNewFile,BufRead Vagrantfile  setlocal filetype=ruby
autocmd MyAutoCmd BufNewFile,BufRead Berksfile    setlocal filetype=ruby
autocmd MyAutoCmd BufNewFile,BufRead Guardfile    setlocal filetype=ruby
autocmd MyAutoCmd BufNewFile,BufRead Capfile      setlocal filetype=ruby
autocmd MyAutoCmd BufNewFile,BufRead *.coffee     setlocal filetype=coffee
autocmd MyAutoCmd BufNewFile,BufRead *.sass       setlocal filetype=sass
autocmd MyAutoCmd BufNewFile,BufRead *.less       setlocal filetype=less
autocmd MyAutoCmd BufNewFile,BufRead *.json       setlocal filetype=javascript
autocmd MyAutoCmd BufNewFile,BufRead *.go         setlocal filetype=go
autocmd MyAutoCmd BufNewFile,BufRead *.mm         setlocal filetype=objc

" Short indent
autocmd MyAutoCmd filetype ruby       call s:set_short_indent()
autocmd MyAutoCmd filetype vim        call s:set_short_indent()
autocmd MyAutoCmd filetype coffee     call s:set_short_indent()
autocmd MyAutoCmd filetype html       call s:set_short_indent()
autocmd MyAutoCmd filetype sass,scss  call s:set_short_indent()
autocmd MyAutoCmd filetype less       call s:set_short_indent()
autocmd MyAutoCmd filetype mkd        call s:set_short_indent()
autocmd MyAutoCmd filetype javascript call s:set_short_indent()
autocmd MyAutoCmd filetype jst        call s:set_short_indent()
autocmd MyAutoCmd filetype typescript call s:set_short_indent()

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
    set fileencodings-=utf-8
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .',utf-8,'. s:enc_euc .',cp932'
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
nmap ,d :set fileformat=dos<CR>
nmap { <C-W><
nmap } <C-W>>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap ,1 :b1<CR>
nnoremap ,2 :b2<CR>
nnoremap ,3 :b3<CR>
nnoremap ,4 :b4<CR>
nnoremap ,5 :b5<CR>
nnoremap ,6 :b6<CR>
nnoremap ,7 :b7<CR>
nnoremap ,8 :b8<CR>
nnoremap ,9 :b9<CR>


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
let g:pdv_cfg_Author = "Hiroyuki Anai<pirosikick@gmail.com>"
let g:pdv_cfg_Copyright = "Copyright 2013 by Hiroyuki Anai<pirosikick@gmail.com>"
let g:pdv_cfg_License = ""

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
\      "script:yui"  : {"type": "text/javascript", "src": "http://yui.yahooapis.com/@/build/yui/yui-min.js"},
\      "script:jquery" : {"type": "text/javascript", "src": "http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"},
\      "script:hbs"  : {"type": "text/x-handlebars-template", "id": "|"},
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
\    },
\  },
\  "eruby":{
\    "snippets":{
\      'erb': "<%= ${child}| %>",
\    },
\  },
\}

" neocomplcache
let g:neocomplcache_enable_at_startup = 1

" Unite.vim
" https://github.com/Shougo/unite.vim
let g:unite_enable_start_insert=1

noremap <C-E><C-E> :UniteWithCurrentDir file<CR>
noremap <C-E><C-B> :Unite buffer<CR>
noremap <C-E><C-F> :UniteWithBufferDir file<CR>
noremap <C-E><C-R> :Unite file_mru<CR>
noremap <C-E><C-Y> :Unite -buffer-name=register register<CR>
noremap <C-O> :Unite outline<CR>
noremap <C-E><C-H> :Unite history/command<CR>
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

" quickrun
let g:quickrun_config = {'*': {'hook/time/enable': '1'},}

" gist.vim
if has('mac')
  let g:gist_clip_command = 'pbcopy'
else
  let g:gist_clip_command = 'xclip -selection clipboard'
endif

let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1

" }}}
