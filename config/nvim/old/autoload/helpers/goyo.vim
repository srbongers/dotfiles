let s:goyo_entered = 0
function! helpers#goyo#enter()
    if executable('tmux') && strlen($TMUX)
        silent !tmux set status off
        silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
    endif
    let s:goyo_entered = 1
    set noshowmode
    set noshowcmd
    set scrolloff=999
    set wrap
    setlocal textwidth=0
    setlocal wrapmargin=0
endfunction

function! helpers#goyo#leave()
    if executable('tmux') && strlen($TMUX)
        silent !tmux set status on
        silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
    endif
    let s:goyo_entered = 0
    set showmode
    set showcmd
    set scrolloff=7
"    set textwidth=80
"    set wrapmargin=8
endfunction
