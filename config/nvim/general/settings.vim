" set leader key
let g:mapleader = "\<Space>"

syntax enable                           " Enables syntax highlighing
set hidden                              " Required to keep multiple buffers open multiple buffers
set nowrap                              " Display long lines as just one line
set encoding=utf-8                      " The encoding displayed
set pumheight=10                        " Makes popup menu smaller
set fileencoding=utf-8                  " The encoding written to file
set ruler              			            " Show the cursor position all the time
set cmdheight=2                         " More space for displaying messages
set iskeyword+=-                      	" treat dash separated words as a word text object"
set mouse=a                             " Enable your mouse
set splitbelow                          " Horizontal splits will automatically be below
set splitright                          " Vertical splits will automatically be to the right
set t_Co=256                           " Support 256 colors
set conceallevel=0                      " So that I can see `` in markdown files
set tabstop=2                           " Insert 2 spaces for a tab
set shiftwidth=2                        " Change the number of space characters inserted for indentation
set smarttab                            " Makes tabbing smarter will realize you have 2 vs 4
set expandtab                           " Converts tabs to spaces
set smartindent                         " Makes indenting smart
set autoindent                          " Good auto indent
set laststatus=0                        " Always display the status line
set number                              " Line numbers
set cursorline                          " Enable highlighting of the current line
set background=dark                     " tell vim what the background color looks like
set showtabline=2                       " Always show tabs
set noshowmode                          " We don't need to see things like -- INSERT -- anymore
" set nobackup                            " This is recommended by coc
" set nowritebackup                       " This is recommended by coc
set updatetime=300                      " Faster completion
set timeoutlen=500                      " By default timeoutlen is 1000 ms
set formatoptions-=cro                  " Stop newline continution of comments
set clipboard=unnamedplus               " Copy paste between vim and everything else
"set autochdir                           " Your working directory will always be the same as your working directory

"set textwidth=80
set wrap linebreak

" Searching
set ignorecase  " Case insensitive searching
set smartcase   " Case-sensitive if expresson contains a capital letter
set hlsearch    " Highlight search results
set incsearch   " Set incremental search, like modern browsers
" set nolazyredraw " Don't redraw while executing macros


" Autocompletion
set complete-=i         " Do not scan the include files during autocomplete (:set complete)
set complete+=kspell    " Turning on word completion (Ctrl-n and Ctrl-p)
set spelllang=en_us     " Set spellchecking language"

" Turn spellcheck on for tex and bib files
augroup auto_spellcheck
  autocmd BufNewFile,BufRead *.tex setlocal spell
  autocmd BufNewFile,BufRead *.bib setlocal spell
augroup END


" Backup and undo behavior
set undofile                    " Use undo files for persistent undo
set backup                      "Turn on backup option
set backupcopy=yes              " Overwrite the original file when saving

" Put all swap and undo files in a central location
if exists('$CACHEDIR')
    set directory=$CACHEDIR/nvim/swap
    set undodir=$CACHEDIR/nvim/undo
    if !isdirectory('$CACHEDIR/nvim/backup')
      silent! execute '!mkdir $CACHEDIR/nvim/backup'
      set backupdir=$CACHEDIR/nvim/backup
    endif
endif

"Meaningful backup name, ex: filename@2015-04-05.14:59
au BufWritePre * let &bex = '@' . strftime("%F.%H:%M")

au! BufWritePost $MYVIMRC source %      " auto source when writing to init.vm alternatively you can run :source $MYVIMRC

" You can't stop me
cmap w!! w !sudo tee % 
