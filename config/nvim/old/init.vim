" .vimrc / init.vim
" The following vim/neovim configuration works for both Vim and NeoVim

source $HOME/.config/nvim/vim-plug/plugins.vim
source $HOME/.config/nvim/general/settings.vim
source $HOME/.config/nvim/keys/mappings.vim

" Themes
"source $HOME/.config/nvim/themes/onedark.vim
source $HOME/.config/nvim/themes/nvcode.vim
source $HOME/.config/nvim/themes/airline.vim

" Add paths to node and python here
if !empty(glob("~/.config/nvim/general/paths.vim"))
  source $HOME/.config/nvim/general/paths.vim
endif

" Plugin Configuration
source $HOME/.config/nvim/plug-config/coc.vim
source $HOME/.config/nvim/plug-config/rainbow.vim
luafile $HOME/.config/nvim/lua/plug-colorizer.lua


" -----------------------------------------------------------------------------
" iColor settings
" -----------------------------------------------------------------------------

" Display the colorscheme (conflict with cursor blinking: don't set
" termguicolors)
"colorscheme vitaminonec


" -----------------------------------------------------------------------------
" Plugin settings, mappings and autocommands
" -----------------------------------------------------------------------------

" .............................................................................
" itchyny/lightline.vim
" .............................................................................
"let g:lightline = {
"      \ 'colorscheme': 'vitaminonec',
"      \ 'active': {
"      \       'left': [ [ 'mode', 'paste' ],
"      \               [ 'gitbranch' ],
"      \               [ 'readonly', 'filetype', 'filename' ]],
"      \       'right': [ [ 'percent' ], [ 'lineinfo' ],
"      \               [ 'fileformat', 'fileencoding' ],
"      \               [ 'gitblame', 'currentfunction',  'cocstatus' ]]
"      \   },
"      \   'component_expand': {
"      \   },
"      \   'component_type': {
"      \       'readonly': 'error'
"      \   },
"      \   'component_function': {
"      \       'fileencoding': 'helpers#lightline#fileEncoding',
"      \       'filename': 'helpers#lightline#fileName',
"      \       'fileformat': 'helpers#lightline#fileFormat',
"      \       'filetype': 'helpers#lightline#fileType',
"      \       'gitbranch': 'helpers#lightline#gitBranch',
"      \       'cocstatus': 'coc#status',
"      \       'currentfunction': 'helpers#lightline#currentFunction',
"      \       'gitblame': 'helpers#lightline#gitBlame'
"      \   },
"      \   'tabline': {
"      \       'left': [ [ 'tabs' ] ],
"      \       'right': [ [ 'close' ] ]
"      \   },
"      \   'tab': {
"      \       'active': [ 'filename', 'modified' ],
"      \       'inactive': [ 'filename', 'modified' ],
"      \   },
"      \   'separator': { 'left': '', 'right': '' },
"      \   'subseparator': { 'left': '', 'right': '' }
"      \ }


" Use auocmd to force lightline update.
"autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" .............................................................................
" lervag/vimtex
" .............................................................................

let g:tex_flavor = 'latex'
let g:vimtex_compiler_latexmk = {
         \ 'backend' : 'nvim',
         \ 'build_dir' : 'build',
         \ 'executable' : 'latexmk',
         \ 'options' : [
         \ '-verbose',
         \ '-file-line-error',
         \ '-synctex=1',
         \ '-interaction=nonstopmode',
         \ ],
         \}
let g:vimtex_compiler_latexmk_engines = {
         \ 'pdflatex' : '-pdf',
         \}
let g:vimtex_view_general_viewer = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'
let g:vimtex_fold_enabled = 0 "So large files can open more easily
"To enable backward search in Skim: Open Skim Preferences -> Sync and 'Check'
"for file changes and reload automatically. Moreover PDF-Tex Sync Support
"should be set to command 'nvr' and arguments '--remote-silent --servername /tmp/nvimsocket +"%line" "%file"'

"" .............................................................................
"" mhinz/vim-startify
"" .............................................................................
"
"" Don't change to directory when selecting a file
"let g:startify_files_number = 5
"let g:startify_change_to_dir = 0
"let g:startify_custom_header = [ ]
"let g:startify_relative_path = 1
"let g:startify_use_env = 1
"let g:startify_session_dir = '$CACHEDIR/nvim/session'
"
"" Custom startup list, only show MRU from current directory/project
"let g:startify_lists = [
"\  { 'type': 'dir',       'header': [ 'Files '. getcwd() ] },
"\  { 'type': function('helpers#startify#listcommits'), 'header': [ 'Recent Commits' ] },
"\  { 'type': 'sessions',  'header': [ 'Sessions' ]       },
"\  { 'type': 'bookmarks', 'header': [ 'Bookmarks' ]      },
"\  { 'type': 'commands',  'header': [ 'Commands' ]       },
"\ ]
"
"let g:startify_commands = [
"\   { 'up': [ 'Update Plugins', ':PlugUpdate' ] },
"\   { 'ug': [ 'Upgrade Plugin Manager', ':PlugUpgrade' ] },
"\ ]
"
"let g:startify_bookmarks = [
"    \ { 'c': '~/.config/nvim/init.vim' },
"    \ { 'g': '~/.gitconfig' },
"    \ { 'z': '~/.zshrc' },
"    \ { 't': '~/.tmux.conf' }
"\ ]
"
"autocmd User Startified setlocal cursorline
"nmap <leader>st :Startify<cr>
"
"
"" .............................................................................
"" moll/vim-bbye
"" .............................................................................
"
"" <Leader>k to kill a buffer (Bd comes from Bdelete)
"nmap <silent> <Leader>k :Bd<CR>
"nmap <silent> <Leader>K :bd!<CR>
"
"" .............................................................................
"" ryanoasis/vim-devicons 
"" .............................................................................
"
"let g:WebDevIconsOS = 'Darwin'
"let g:WebDevIconsUnicodeDecorateFolderNodes = 1
"let g:DevIconsEnableFoldersOpenClose = 1
"let g:DevIconsEnableFolderExtensionPatternMatching = 1
"
"
"" .............................................................................
"" scrooloose/nerdtree
"" " .............................................................................
"
"let NERDTreeShowHidden=1
"let NERDTreeDirArrowExpandable = "\u00a0" " make arrows invisible
"let NERDTreeDirArrowCollapsible = "\u00a0" " make arrows invisible
"let NERDTreeNodeDelimiter = "\u263a" " smiley face
"
"" Toggle NERDTree
"
"function! ToggleNerdTree()
"    if @% != "" && @% !~ "Startify" && (!exists("g:NERDTree") || (g:NERDTree.ExistsForTab() && !g:NERDTree.IsOpen()))
"        :NERDTreeFind
"    else
"        :NERDTreeToggle
"    endif
"endfunction
"" toggle nerd tree
"nmap <silent> <leader>n :call ToggleNerdTree()<cr>
"" find the current file in nerdtree without needing to reload the drawer
"nmap <silent> <leader>nf :NERDTreeFind<cr>
"
"" .............................................................................
"" Xuyuanp/nerdtree-git-plugin
"" .............................................................................
"
"let g:NERDTreeIndicatorMapCustom = {
"\ "Modified"  : "✹",
"\ "Staged"    : "✚",
"\ "Untracked" : "✭",
"\ "Renamed"   : "➜",
"\ "Unmerged"  : "═",
"\ "Deleted"   : "✖",
"\ "Dirty"     : "✗",
"\ "Clean"     : "✔︎",
"\ 'Ignored'   : '☒',
"\ "Unknown"   : "?"
"\ }
"
"
"" .............................................................................
"" Sirver/ultisnips
"" .............................................................................
"
" let g:UltiSnipsExpandTrigger="<C-l>"
" let g:UltiSnipsJumpForwardTrigger="<C-j>"
" let g:UltiSnipsJumpBackwardTrigger="<C-k>"
"
"
"" .............................................................................
"" mbbill/undotree
"" .............................................................................
"
"nnoremap <Leader>u :UndotreeToggle<CR>
"
"" .............................................................................
"
"" .............................................................................
"
"autocmd! User GoyoEnter nested call helpers#goyo#enter()
"autocmd! User GoyoLeave nested call helpers#goyo#leave()
"
"" .............................................................................
"" junegunn/fzf.vim
"" .............................................................................
"let g:fzf_layout = { 'down': 25 }
"
"if isdirectory(".git")
"    " if in a git project, use :GFiles
"    nmap <silent> <leader>f :GitFiles --cached --others --exclude-standard<cr>
"else
"    " otherwise, use :FZF
"    nmap <silent> <leader>f :Files<cr>
"endif
"
"map <silent> <Leader>b :Buffers<CR>
"" Show untracked files, too
"map <silent> <Leader>g :GFiles?<CR>
"
"map <silent> <leader>l :Lines<CR>
"
"nmap <leader><tab> <plug>(fzf-maps-n)
"xmap <leader><tab> <plug>(fzf-maps-x)
"omap <leader><tab> <plug>(fzf-maps-o)
"
"" Insert mode completion
"imap <c-x><c-k> <plug>(fzf-complete-word)
"imap <c-x><c-f> <plug>(fzf-complete-path)
"imap <c-x><c-j> <plug>(fzf-complete-file-ag)
"imap <c-x><c-l> <plug>(fzf-complete-line)
"
"command! -bang -nargs=* Find call fzf#vim#grep(
"    \ 'rg --column --line-number --no-heading --follow --color=always '.<q-args>, 1,
"    \ <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)
"command! -bang -nargs=? -complete=dir Files
"    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:50%', '?'), <bang>0)
"command! -bang -nargs=? -complete=dir GitFiles
"    \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview('right:50%', '?'), <bang>0)
"
"
"" .............................................................................
"" vim-scripts/YankRing.vim
"" .............................................................................
"
""silent !mkdir $CACHEDIR/nvim/yankring > /dev/null 2>&1
""let g:yankring_history_dir = '$CACHEDIR/nvim/yankring'
""let g:yankring_history_file = 'yankring-history'
""let g:yankring_min_element_length = 2
""nnoremap <leader>y :YRShow<CR>
"
"
"" .............................................................................
"" raghur/vim-ghost
"" .............................................................................
"
"let g:ghost_darwin_app = 'iTerm2'
"
"map <silent> <leader>gs :GhostStart<CR>
"map <silent> <leader>ge :GhostStop<CR>
"
"" .............................................................................
"" Final setup
"" .............................................................................
"syntax on
"filetype plugin indent on



