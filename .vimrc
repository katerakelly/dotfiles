" vim not vi
set nocompatible
filetype off

" Vundle plugin manager
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" use Vundle to install plugins
Plugin 'vim-airline/vim-airline' " airline status bar
Plugin 'ctrlpvim/ctrlp.vim' " fuzzy search
Plugin 'mileszs/ack.vim'
Plugin 'davidhalter/jedi-vim'

" all Plugins added before here
" ...
call vundle#end()            " required
filetype plugin indent on    " required

"  Manual customizations (stolen from shelhamer)

"  allow hidden buffers
set title     " show filename in terminal title
set hidden    " hide buffers instead of closing, preserving the buffer
set autoread  " auto re-read files on change

" enbale list of buffers across the top of the screen
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" shortcut for listing and going to buffer
nnoremap gb :ls<CR>:b<Space>

" open a new split when jumping to def with jedi
let g:jedi#use_splits_not_buffers = 'winwidth'

" indentation
set autoindent    " always autoindent
set copyindent    " copy the previous indentation on autoindenting
set tabstop=4     " tab = 2 spaces
set softtabstop=4 " tab = 2 spaces (when deleting)
set shiftwidth=4  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set expandtab     " spaces instead of tabs
set smarttab      " insert tabs on the start of a line according to
                  " shiftwidth, not tabstop

" spaces: show non-breaking (and mark long lines)
set list
set listchars=extends:#,nbsp:.

" navigation
set number        " number lines
set ruler         " show row, col of cursor
set scrolloff=2   " scroll 2 lines away from border

" syntax highlighting
syntax on

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

" completion
set completeopt=longest,menuone

" complete by tab
inoremap <tab> <c-r>=Smart_TabComplete()<CR>

" map by , instead of /
let mapleader=','

" buffer alternation, next/prev, close
map ga <C-^>
nmap gn :bn<CR>
nmap gp :bp<CR>
nmap gk :bp<bar>bd #<CR>

" search
set hlsearch      " highlight search
set incsearch     " reveal search incrementally as typed
set ignorecase    " case-insensitive match...
set smartcase     " ...except when uppercase letters are given

" use ag for search, fall back to ack if not available
 if executable('ag')
  let g:ackprg = 'ag --vimgrep'
 endif

" use ag over grep
set grepprg=ag\ --nogroup\ --nocolor

" configure ctrlp
let g:ctrlp_working_path_mode = 0 " start search from dir vim was started in
let g:ctrlp_map = '<leader>t'
map <c-p>  :CtrlP getcwd()<CR>
let g:ctrlp_switch_buffer = '' " always open a new instance for side-by-side
if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif
" have ctrlp use ag for searching (for speed)
let g:ctrlp_user_command = 'ag %s -l -f --nocolor -g ""' " silver searcher

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" ignore hlsearch state on start
set viminfo='128,<256,s10,h
set directory=~/.vim/tmp//,/var/tmp//,/tmp//,.

" ignore types
set wildignore+=.svn,CVS,.git,*.pyc,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pdf,*.bak,*.beam,*/tmp/*,*.zip,log/**,node_modules/**,target/**,tmp/**,*.rbc
set wildmode=longest,list,full


" strip trailing whitespace
function! StripTrailing(...)
  let no_strip_types = []
  if a:0 > 0
    no_strip_types = a:1
  endif
  " save last search, cursor position
  let _s=@/
  let l = line('.')
  let c = col('.')
  if index(no_strip_types, &ft) < 0 " whitespace isn't evil for all files
    %s/\s\+$//e
  endif
  let @/=_s
  call cursor(l, c)
endfunction

" smart tab complete from http://vim.wikia.com/wiki/Smart_mapping_for_tab_completion
function! Smart_TabComplete()
  let line = getline('.')                         " current line

  let substr = strpart(line, -1, col('.')+1)      " from the start of the current
                                                  " line to one character right
                                                  " of the cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"                         " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endfunction

" file types
filetype on
filetype indent on
filetype plugin on

" strip trailing whitespace on save
let no_strip_types = ['diff', 'markdown', 'pandoc']
autocmd BufWritePre *.* call StripTrailing(no_strip_types)

" enable backspace
set backspace=indent,eol,start
