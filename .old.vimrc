" ----------------------------
" Plugin Manager
" ----------------------------
" Source Plug config
if filereadable(expand("~/.vimrc.plug"))
    source ~/.vimrc.plug
endif

" ----------------------------
" General Settings
" ----------------------------
set nocompatible                " Disable compatibility mode
syntax on                       " Enable syntax highlighting
set encoding=UTF-8              " Set encoding to UTF-8
set mouse=a                     " Enable mouse support
set clipboard=unnamed           " Use system clipboard

" ----------------------------
" Performance Tweaks
" ----------------------------
set updatetime=250              " Reduce update time for better performance

" ----------------------------
" Appearance and UI
" ----------------------------
set number                      " Enable line numbers
set relativenumber              " Enable relative line numbers
set numberwidth=4               " Set number column width
set signcolumn=number           " Display sign column in number column
set cursorline                  " Highlight the current line
set scrolloff=10                " Minimal number of lines above/below cursor
set nowrap                      " Disable line wrapping
set noshowmode                  " Disable mode display (statusline handles it)
set termguicolors               " Enable 24-bit color
colorscheme onedark             " Set theme

" ----------------------------
" Tabs and Indentation
" ----------------------------
set tabstop=4                   " Tab width
set softtabstop=4               " Spaces for <Tab>
set shiftwidth=4                " Spaces for indentation
set expandtab                   " Convert tabs to spaces
set smartindent                 " Enable smart indentation

" ----------------------------
" Search Settings
" ----------------------------
set incsearch                   " Show search matches as you type
set nohlsearch                  " Disable search highlight
set ignorecase                  " Case-insensitive search
set smartcase                   " Enable smart case-sensitive search

" ----------------------------
" Splits and Buffers
" ----------------------------
set splitbelow                  " Open horizontal splits below
set splitright                  " Open vertical splits to the right
set hidden                      " Allow buffer switching without saving

" ----------------------------
" Undo and Backup
" ----------------------------
set noswapfile                  " Disable swap files
set nobackup                    " Disable backups
set undodir=~/config/nvim/undodir " Set undo directory
set undofile                    " Enable persistent undo

" ----------------------------
" Remaps
" ----------------------------
" Set leader key
let mapleader = ' '

" Use k+j vor Esc
inoremap kj <esc>
vnoremap kj <esc>

" NERDTree
nnoremap <leader>e :NERDTreeToggle<CR> " Toggle NERDTree

" Increment/Decrement numbers
nnoremap <leader>+ <C-a>
nnoremap <leader>- <C-x>

" Buffer Management
nnoremap <leader>bx :bwipeout<CR>
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bl :ls<CR>

" Window Management
nnoremap <leader>sv <C-w>v
nnoremap <leader>sh <C-w>s
nnoremap <leader>se <C-w>=
nnoremap <leader>sx :close<CR>

" Tab Management
nnoremap <leader>to :tabnew<CR>
nnoremap <leader>tx :tabclose<CR>
nnoremap <leader>tn :tabn<CR>
nnoremap <leader>tp :tabp<CR>
nnoremap <leader>tb :tab split<CR>

" Pane Navigation with hjkl
nnoremap <C-h> <C-w>h           " Move to the left pane
nnoremap <C-j> <C-w>j           " Move to the bottom pane
nnoremap <C-k> <C-w>k           " Move to the top pane
nnoremap <C-l> <C-w>l           " Move to the right pane

" Pane Navigation with arrows
nnoremap <C-Left>  <C-w>h           " Move to the left pane
nnoremap <C-Down>  <C-w>j           " Move to the bottom pane
nnoremap <C-Up>    <C-w>k           " Move to the top pane
nnoremap <C-Right> <C-w>l           " Move to the right pane

" FZF
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fb :Buffers<CR>

" Center screen after scrolling
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Conditional Pane/Tab Navigation
function! MoveLeftOrTabPrevious()
  if winnr('$') > 1
    wincmd h
  else
    tabprevious
  endif
endfunction

function! MoveRightOrTabNext()
  if winnr('$') > 1
    wincmd l
  else
    tabnext
  endif
endfunction

nnoremap <S-Left> :call MoveLeftOrTabPrevious()<CR>
nnoremap <S-Right> :call MoveRightOrTabNext()<CR>

nnoremap <S-h> :call MoveLeftOrTabPrevious()<CR>
nnoremap <S-l> :call MoveRightOrTabNext()<CR>


" ----------------------------
" Airline Configuration
" ----------------------------
let g:airline_powerline_fonts = 1
let g:airline_section_x = ''
let g:airline_section_y = ''
let g:airline_section_z = '%3p%% | %l:%c' " File percentage, line, column
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_min_count = 2

" ----------------------------
" Autocommands
" ----------------------------
autocmd BufWritePre * %s/\s\+$//e  " Remove trailing whitespace on save
