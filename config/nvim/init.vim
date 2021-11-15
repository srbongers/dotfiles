" General Settings
source $HOME/.config/nvim/vim-plug/plugins.vim
source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/keys/mappings.vim

if exists('g:vscode')
  " VS Code extension
  source $HOME/.config/nvim/vscode/settings.vim
  source $HOME/.config/nvim/plug-config/easymotion.vim
endif

" Themes
source $HOME/.config/nvim/themes/onedark.vim
source $HOME/.config/nvim/themes/airline.vim

" Plugin Configuration
source $HOME/.config/nvim/plug-config/coc.vim
source $HOME/.config/nvim/plug-config/rnvimr.vim
source $HOME/.config/nvim/plug-config/vimtex.vim
"source $HOME/.config/nvim/plug-config/wiki.vim
"source $HOME/.config/nvim/plug-config/vimwiki.vim
source $HOME/.config/nvim/plug-config/vimghost.vim

" Add paths to node and python here
"if !empty(glob("~/.config/nvim/general/paths.vim"))
"  source $HOME/.config/nvim/general/paths.vim
"endif


let g:python_highlight_all = 1
