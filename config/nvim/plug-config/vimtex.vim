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
