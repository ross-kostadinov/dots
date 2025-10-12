" ----------------------------
" Plugin Manager
" ----------------------------

let s:plug_path = expand('~/.vim/autoload/plug.vim')
let s:plug_dir  = expand('~/.vim/autoload')
let s:plug_url  = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

if !filereadable(s:plug_path)
  if !isdirectory(s:plug_dir)
    call mkdir(s:plug_dir, 'p')
  endif
  if executable('curl')
    silent execute '!curl -fLo ' . shellescape(s:plug_path) . ' --create-dirs ' . shellescape(s:plug_url)
  elseif executable('wget')
    " Some distros don’t create dirs automatically with wget; we did mkdir above.
    silent execute '!wget -O ' . shellescape(s:plug_path) . ' ' . shellescape(s:plug_url)
  else
    echohl WarningMsg
    echom 'vim-plug bootstrap failed: install curl or wget, or pre-copy plug.vim to ~/.vim/autoload/'
    echohl None
  endif
  " On first successful download, install plugins after startup
  if filereadable(s:plug_path)
    augroup PlugBootstrap
      autocmd!
      autocmd VimEnter * ++once PlugInstall --sync | source $MYVIMRC
    augroup END
  endif
endif

" --- Plugins ---
call plug#begin('~/.vim/plugged')
  " Core UX
  Plug 'joshdick/onedark.vim'
  Plug 'vim-airline/vim-airline'
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'rbong/vim-flog'
  Plug 'preservim/nerdtree'      " or 'lambdalisue/fern.vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'jiangmiao/auto-pairs'
  Plug 'Yggdroot/indentLine'

  " LSP/diagnostics/completion (pick one path)
  Plug 'dense-analysis/ale'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'prabirshrestha/vim-lsp'

  Plug 'liuchengxu/vim-which-key'
call plug#end()


" ----------------------------
" General Settings
" ----------------------------
set nocompatible                " Disable compatibility mode
syntax on                       " Enable syntax highlighting
set encoding=UTF-8              " Set encoding to UTF-8
set mouse=a                     " Enable mouse support
set clipboard=unnamedplus        " Use system clipboard

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
set tabstop=2                   " Tab width
set softtabstop=2               " Spaces for <Tab>
set shiftwidth=2                " Spaces for indentation
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
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

" Use k+j vor Esc
inoremap kj <esc>
vnoremap kj <esc>

" NERDTree
nnoremap <leader>e :NERDTreeToggle<CR> " Toggle NERDTree

" Increment/Decrement numbers
nnoremap <leader>+ <C-a>
nnoremap <leader>- <C-x>

" Buffer Management
nnoremap <leader>bo :enew<CR>
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

" Move between buffers
nnoremap <S-h> :bprevious<CR>
nnoremap <S-l> :bnext<CR>

" Optionally also use Shift + arrows
nnoremap <S-Left> :bprevious<CR>
nnoremap <S-Right> :bnext<CR>

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
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Resizing Windows
nnoremap <C-Up>    :resize +2<CR>
nnoremap <C-Down>  :resize -2<CR>
nnoremap <C-Left>  :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>


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

" optional: show key hints after 500ms
let g:which_key_timeout = 100

" register groups and mappings manually
call which_key#register(',', 'g:which_key_map')

let g:which_key_map = {}

" Create a Git group under <leader>g
let g:which_key_map.g = {
      \ 'name': '+git',
      \ 's': 'Status',
      \ 'a': 'Add current file',
      \ 'c': 'Commit',
      \ 'p': 'Push',
      \ 'P': 'Pull',
      \ 'b': 'Blame',
      \ 'd': 'Diff',
      \ }

" actual mappings
nnoremap <leader>gs :Git<CR>
nnoremap <leader>ga :Gwrite<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gP :Git pull<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gd :Gdiffsplit<CR>
