
"" -----------------------------------------------------------------------------
" Basic Settings
"   Research any of these by running :help <setting>
" ------------------------------------------------------------------------------

" Appearance
syntax enable                           " Enables syntax highlighing

set number relativenumber   " Show line and relative line numbers
set autoindent              " Automatically set indent of new line
set laststatus=2            " Show the status line all the time
set so=7                    " Set scroll offset to 7 lines above and below the cursors - when moving vertical
set hidden                  " Current buffer can be put into background
set showcmd                 " Show commands in the cmd area (not working together with noshowmode)
set noshowmode              " Don't show which mode disabled for PowerLine
set cmdheight=1             " Command bar height
set showmatch               " Show matching braces
set updatetime=300          " More responsive UI updates
set shortmess+=c            " Don't give ins-completion-menu messages
set signcolumn=yes          " Always show signcolumns
set splitbelow              " New horizontal split is below
set splitright              " New vertical split is to the right"

set showtabline=2           " Always show tabs

if (has('nvim'))
    " Show results of substition as they're happening
    " but don't open a split
    set inccommand=nosplit
endif

" toggle invisible characters
set list
set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪

" Behavior
set encoding=UTF-8              " Use UTF-8 encoding
set autoread                    " Detect when file is changed
set backspace=indent,eol,start  " Make backspace behave in a sane manner
set clipboard=unnamed           " OS X clipboard sharing
set history=1000                " Change history to 1000"
set fileformat=unix             " Use unix (\n) line endings
set mouse=a                     " Use mouse for scroll or window size

" Searching
set ignorecase  " Case insensitive searching
set smartcase   " Case-sensitive if expresson contains a capital letter
set hlsearch    " Highlight search results
set incsearch   " Set incremental search, like modern browsers
" set nolazyredraw " Don't redraw while executing macros

" Tab control
"set expandtab       " Turn a tabs into spaces
set smarttab        " Tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
set tabstop=4       " The visible width of tabs
set softtabstop=4   " Edit as if the tabs are 4 characters wide
set shiftwidth=4    " Number of spaces to use for indent and unindent
set shiftround      " Round indent to a multiple of 'shiftwidth'
set indentexpr&     " Turn of indentation after epxression

" Explicitly tell vim that the terminal supports 256 colors
set t_Co=256
" Enable shapes, "Cursor" highlight, and blinking
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
\,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
\,sm:block-blinkwait175-blinkoff150-blinkon175

" Autocompletion
set complete-=i         " Do not scan the include files during autocomplete (:set complete)
set complete+=kspell    " Turning on word completion (Ctrl-n and Ctrl-p)
set spelllang=en_us     " Set spellchecking language"

" Backup and undo behavior
set undofile                    " Use undo files for persistent undo
set backup                      "Turn on backup option
set backupcopy=yes              " Overwrite the original file when saving

" Put all swap and undo files in a central location
if exists('$CACHEDIR')
    set directory=$CACHEDIR/nvim/swap
    set undodir=$CACHEDIR/nvim/undo
    set backupdir=$CACHEDIR/nvim/backup
endif

"Meaningful backup name, ex: filename@2015-04-05.14:59
au BufWritePre * let &bex = '@' . strftime("%F.%H:%M")

"" -----------------------------------------------------------------------------
" Auto Settings
" ------------------------------------------------------------------------------

" file type specific settings
augroup configgroup
autocmd!

" automatically resize panes on resize
autocmd VimResized * exe 'normal! \<c-w>='
autocmd BufWritePost .vimrc,init.vim source %
" save all files on focus lost, ignoring warnings about untitled buffers
autocmd FocusLost * silent! wa

augroup END


" au! BufWritePost $MYVIMRC source %      " auto source when writing to init.vm alternatively you can run :source $MYVIMRC
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
