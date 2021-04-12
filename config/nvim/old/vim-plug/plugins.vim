" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

set nocompatible

call plug#begin('~/.vim/autoload/plugged') 

" Themes
"Plug 'gkapfham/vim-vitamin-onec'        " Color scheme
"Plug 'joshdick/onedark.vim'
Plug 'christianchiarulli/nvcode.vim'

"Status line
Plug 'vim-airline/vim-airline'

Plug 'norcalli/nvim-colorizer.lua'
Plug 'junegunn/rainbow_parentheses.vim'

"Plug 'sheerun/vim-polyglot'

"Plug 'mhinz/vim-startify'               " Startify: Fancy startup screen for vim
"Plug 'tpope/vim-surround'               " For manipulating surroundings in pairs (parens, etc.)
"Plug 'tpope/vim-repeat'                 " Enables repeating other supported plugins (the . command)
"Plug 'tpope/vim-abolish'                " Substitute/search/abbreviate multiple variants of a word
"" Plug 'tpope/vim-sleuth'                 " Detect indent style (tabs vs. spaces)
"Plug 'nelstrom/vim-visual-star-search'  " Modify * to also work with visual selections.
"Plug 'tpope/vim-fugitive'               " Git utilities
"Plug 'sickill/vim-pasta'                " context-aware pasting
"Plug 'moll/vim-bbye'                    " Close buffers but keep splits
""Plug 'itchyny/lightline.vim'            " Flashy status bar
"Plug 'ryanoasis/vim-devicons'           " Load devicons
"Plug 'Sirver/ultisnips'                 " Snippets plugin
"Plug 'christoomey/vim-tmux-navigator'   " Easy movement between vim and tmux panes
"Plug 'mbbill/undotree'                  " Visualize the undo tree
"Plug 'junegunn/goyo.vim'                " Distraction-free writing
"Plug 'junegunn/vim-peekaboo'            " Show content of the register when hitting \" command
"Plug 'Sirver/ultisnips'                 " Snippets plugin
"Plug 'editorconfig/editorconfig-vim'    " .editorconfig support
""Plug 'vim-scripts/YankRing.vim'         " Maintains a  history of previous yanks, changes and deletes

" Vim-ghost server
"Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}

" Integrate fzf with Vim.
"Plug '/usr/local/opt/fzf'
"Plug 'junegunn/fzf.vim'

" NERDTree setup
"Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
"Plug 'Xuyuanp/nerdtree-git-plugin'
"Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Filetype plugins
Plug 'lervag/vimtex'

call plug#end()

" Run PlugInstall if there are missing plugins
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
