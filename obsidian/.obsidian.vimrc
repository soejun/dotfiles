"https://github.com/replit/codemirror-vim/blob/master/src/vim.js
"Have j and k navigate visual lines rather than logical ones
let mapleader="\<space>"

set clipboard=unnamed " yank to system clipboard
set ignorecase " ignorecase for search
set smartcase " case sensitive if uppercase is used
set number
set hlsearch

nmap j gj
nmap k gk

"Remove search highlights"
nmap <leader>nh :nohl

" Go back and forward with Ctrl+O and Ctrl+I
" (make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <C-o> :back
exmap forward obcommand app:go-forward
nmap <C-i> :forward

exmap focusRight obcommand editor:focus-right
noremap <C-l> :focusRight
exmap focusLeft obcommand editor:focus-left
noremap <C-h> :focusLeft
exmap focusTop obcommand editor:focus-top
noremap <C-j> :focusTop
exmap focusBottom obcommand  editor:focus-bottom
noremap <C-k> :focusBottom

exmap splitVertical obcommand workspace:split-vertical
exmap splitHorizontal obcommand workspace:split-horizontal
noremap <leader>sv :splitVertical
noremap <leader>sh :splitHorizontal
