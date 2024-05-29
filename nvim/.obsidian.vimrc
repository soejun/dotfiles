"https://github.com/replit/codemirror-vim/blob/master/src/vim.js
"Have j and k navigate visual lines rather than logical ones
nmap j gj
nmap k gk

"Remove search highlights"
" nmap <Space-n-h> :nohl

" Go back and forward with Ctrl+O and Ctrl+I
" (make sure to remove default Obsidian shortcuts for these to work)
set clipboard=unnamed
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
noremap <C-,> :splitVertical
noremap <C-.> :splitHorizontal






