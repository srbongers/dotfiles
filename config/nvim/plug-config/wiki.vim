let g:wiki_root = '~/wiki'

let g:wiki_export = {
    \ 'args' : '',
    \ 'from_format' : 'markdown',
    \ 'ext' : 'pdf',
    \ 'link_ext_replace': v:false,
    \ 'view' : v:true,
    \ 'output': 'printed',
    \}

let g:wiki_viewer = {'pdf': 'open'}

let g:wiki_file_open = 'WikiFileOpen'

function! WikiFileOpen(...) abort dict
  if self.path =~# 'pdf$'
    silent execute '!open -a skim' fnameescape(self.path) '&'
    return 1
  endif

  if self.path =~# 'png$'
    silent execute '!feh -.' fnameescape(self.path) '&'
    return 1
  endif

  if self.path =~# '\v(docx|xls)$'
    silent execute '!libreoffice' fnameescape(self.path) '&'
    return 1
  endif
endfunction
