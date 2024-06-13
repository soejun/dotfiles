" Set leader key
let mapleader = " "


" General settings
" set spelllang=en             " Set spell check language to English
" set shortmess+=sI            " Disable intro message

syntax on

set mouse=a                  " Enable mouse support

set cursorline               " Highlight the current line

set expandtab                " Use spaces instead of tabs
set smartindent              " Automatically insert indents in some cases

set shiftwidth=2             " Number of spaces to use for each step of (auto)indent
set tabstop=2                " Number of spaces that a <Tab> in the file counts for
set softtabstop=2            " Number of spaces that a <Tab> counts for while editing

set hlsearch                 " Enable highlight search pattern
set ignorecase               " Ignore case in search patterns
set smartcase                " Override 'ignorecase' if the search pattern contains uppercase letters

" show the matching part of pairs [] {} and () "
set showmatch

set number                   " Show line numbers
set numberwidth=2            " Set number column width to 2
set signcolumn=yes           " Always show the sign column

set splitbelow               " Split windows below the current window
set splitright               " Split windows to the right of the current window

" enable color themes "
if !has('gui_running')
	set t_Co=256
endif
set termguicolors            " Enable true color support
colorscheme slate

" set timeoutlen=400           " Time to wait for a mapped sequence to complete (in milliseconds)
set undofile                 " Save undo history to an undo file
set updatetime=25            " Faster completion (default is 4000 ms)

set foldcolumn=1             " Show fold column
set foldlevel=99             " Set initial fold level
set foldlevelstart=-1        " Start editing with all folds open
set foldenable               " Enable folding
set fillchars=eob:\ ,fold:\ ,foldopen:\ ,foldsep:\ ,foldclose:\ " Set fill characters
set whichwrap+=<,>,[,],h,l   " Allow moving the cursor through wrapped lines with h, l, <Left>, and <Right>
"
" sudo apt install vim-gtk3 for clipboard support on gnome
set clipboard^=unnamed,unnamedplus

" " Key mappings

" Normal mode
" Clear search highlights
nnoremap <leader>nh :noh<CR>

" Move to the left window
nnoremap <C-h> <C-w><Left>

" Move to the right window
nnoremap <C-l> <C-w><Right>

" Move to the window below
nnoremap <C-j> <C-w>j
" Move to the window above
nnoremap <C-k> <C-w>k
" Split window vertically
nnoremap <leader>sv <C-w>v
" Split window horizontally
nnoremap <leader>sh <C-w>s
" Make split windows equal width and height
nnoremap <leader>se <C-w>=
" Close the current split window
nnoremap <leader>sx :close<CR>
" Save the file
nnoremap <C-s> :w<CR>
" Copy the entire file to the clipboard
nnoremap <C-c> :%y+<CR>
" Create a new buffer
nnoremap <leader>b :enew<CR>

" Don't copy the replaced text after pasting
xnoremap p p:let @+=@0<CR>:let @"=@0<CR>
