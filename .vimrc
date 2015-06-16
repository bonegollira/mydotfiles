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
  if &compatible
    set nocompatible
  endif

  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'tpope/vim-rails'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'othree/html5.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'mattn/gist-vim', { 'depends': 'mattn/webapi-vim' }
NeoBundle 'vim-scripts/sudo.vim'
NeoBundle 'Blackrush/vim-gocode'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'matchit.zip'
NeoBundle 'ekalinin/Dockerfile.vim'
NeoBundle 'mxw/vim-jsx'
NeoBundle 'elzr/vim-json'
NeoBundle 'editorconfig/editorconfig-vim'
NeoBundle 'bronson/vim-trailing-whitespace'
NeoBundle 'rking/ag.vim'
NeoBundle 'tyru/open-browser-github.vim', { "depends": ['tyru/open-browser.vim'] }
NeoBundle 'vim-jp/vim-go-extra'
NeoBundle 'markcornick/vim-terraform'
NeoBundle "ctrlpvim/ctrlp.vim"
NeoBundle "nixprime/cpsm", { 'build': { 'unix': './install.sh' } }

NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'

NeoBundle 'Shougo/vimproc.vim', {
  \ 'build' : {
  \     'windows' : 'tools\\update-dll-mingw',
  \     'cygwin' : 'make -f make_cygwin.mak',
  \     'mac' : 'make -f make_mac.mak',
  \     'linux' : 'make',
  \     'unix' : 'gmake',
  \    },
  \ }

NeoBundle 'pirosikick/vim-snippets'

NeoBundleLazy 'pangloss/vim-javascript',
  \ { 'autload': { 'filetypes': ['javascript'] } }

NeoBundleLazy 'othree/yajs.vim',
  \ { 'autoload': { 'filetypes': ['javascript'] } }

NeoBundleLazy 'nono/vim-handlebars',
  \ { 'autoload': { 'filetypes': ['html'] } }

NeoBundle 'briancollins/vim-jst',
  \ { 'autoload': { 'filetypes': ['jst'] } }

NeoBundleLazy 'leafgarland/typescript-vim',
  \ { 'autoload' : { 'filetypes': ['typescript'] } }

NeoBundleLazy 'jason0x43/vim-js-indent',
  \ {
  \ 'autoload' : { 'filetypes': ['javascript', 'typescript', 'html'] }
  \ }
let g:js_indent_typescript = 1

NeoBundleLazy 'clausreinke/typescript-tools',
  \ {
  \ 'build' : 'npm install -g',
  \ 'autoload' : { 'filetypes': ['typescript'] }
  \ }

NeoBundleLazy 'kchmck/vim-coffee-script',
  \ { 'autoload': { 'filetypes': ['coffee'] } }

NeoBundleLazy 'wavded/vim-stylus',
  \ { 'autoload': { 'filetypes': ['stylus'] } }

NeoBundleLazy 'groenewege/vim-less',
  \ { 'autoload': { 'filetypes': ['less'] } }

NeoBundleLazy 'plasticboy/vim-markdown',
  \ { 'autoload': { 'filetypes': ['mkd'] } }

NeoBundleLazy 'mattn/emmet-vim',
  \ { 'autoload': { 'filetypes': ['css', 'javascript', 'html'] } }

call neobundle#end()

filetype plugin indent on

NeoBundleCheck
" }}}

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

if (exists('+colorcolumn'))
  set colorcolumn=80
  highlight ColorColumn ctermbg=9
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
set background=dark

let g:solarized_termcolors=256
try
  colorscheme solarized
catch
endtry

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

set undodir=~/tmp/vim

" Using the mouse on a terminal.
" http://yskwkzhr.blogspot.jp/2013/02/use-mouse-on-terminal-vim.html
if has('mouse')
  set mouse=a
  if has('mouse_sgr')
    set ttymouse=sgr
  elseif v:version > 703 || v:version is 703 && has('patch632')
    set ttymouse=sgr
  else
    set ttymouse=xterm2
  endif
endif

if has('clipboard')
  set clipboard=unnamed
endif

" }}}

" Autocmd {{{

function! s:set_short_indent()  "{{{
  setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
endfunction " }}}

augroup MyAutoCmd
  autocmd!
augroup END

" Filetype detection
autocmd MyAutoCmd BufNewFile,BufRead *.coffee     setlocal filetype=coffee
autocmd MyAutoCmd BufNewFile,BufRead *.sass       setlocal filetype=sass
autocmd MyAutoCmd BufNewFile,BufRead *.less       setlocal filetype=less
autocmd MyAutoCmd BufNewFile,BufRead *.go         setlocal filetype=go
autocmd MyAutoCmd BufNewFile,BufRead *.mm         setlocal filetype=objc
autocmd MyAutoCmd BufNewFile,BufRead *.ect        setlocal filetype=jst

" Load skeleton
autocmd BufNewFile *.js 0r ~/.vim/templates/skeleton.js
autocmd BufNewFile *.jsx 0r ~/.vim/templates/skeleton.jsx
autocmd BufNewFile gulpfile.js 0r ~/.vim/templates/gulpfile.js
autocmd BufNewFile gulpfile.es6 0r ~/.vim/templates/gulpfile.es6

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
autocmd MyAutoCmd filetype neosnippet call s:set_short_indent()

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

" <Leader>
let mapleader = ","

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
let g:neocomplete#enable_at_startup = 1

" ag
nnoremap <space>/ :Ag 

" quickrun
let g:quickrun_config = {
      \ '*': {'hook/time/enable': '1'},
      \'javascript': { "cmdopt" : "--harmony" },
      \}

" gist.vim
if has('mac')
  let g:gist_clip_command = 'pbcopy'
else
  let g:gist_clip_command = 'xclip -selection clipboard'
endif

let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1

" neosnippet.vim
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

" vim-fugitive
noremap [fugtive] <Nop>
map <Leader>g [fugtive]

nnoremap <silent>[fugtive]s :Gstatus<CR>
nnoremap <silent>[fugtive]a :Gwrite 
nnoremap <silent>[fugtive]c :Gcommit<CR>
nnoremap <silent>[fugtive]b :Gblame<CR>
nnoremap <silent>[fugtive]d :Gdiff<CR>
nnoremap <silent>[fugtive]r :Gread<CR>

" open-browser-github.vim
noremap [obg] <Nop>
map <Leader>o [obg]

noremap <silent>[obg]f :OpenGithubFile<CR>
nnoremap <silent>[obg]i :OpenGithubIssue
nnoremap <silent>[obg]p :OpenGithubPullReq

" CtrlP with cpsm
let g:ctrlp_match_func = {'match': 'cpsm#CtrlPMatch'}
nnoremap <C-b> :<C-u>CtrlPBuffer<CR>
" }}}
