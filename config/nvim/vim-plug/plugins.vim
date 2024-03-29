" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')

  if exists('g:vscode')
    " Easy motion for VSCode
    Plug 'asvetliakov/vim-easymotion'
  endif

    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
   
    " File Explorer
    " Plug 'scrooloose/NERDTree'
    
    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'

    " Vimwiki
    "Plug 'vimwiki/vimwiki'
    "Plug 'lervag/wiki.vim'
    "Plug 'lervag/wiki-ft.vim'

    " Themes
    Plug 'joshdick/onedark.vim'

    " Intellisense
    Plug 'neoclide/coc.nvim', {'branch': 'release'} 

    " Status Line
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    " Ranger
    Plug 'kevinhwang91/rnvimr', {'do': 'make sync'} 
    
    " Filetype plugins
    Plug 'lervag/vimtex'
    
    Plug 'rafi/vim-venom', { 'for': 'python' }

    " Vim Ghost
    Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}

call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif
