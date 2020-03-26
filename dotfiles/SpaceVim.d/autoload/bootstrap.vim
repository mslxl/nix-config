function! bootstrap#before() abort
  let g:vimtex_compiler_latexmk_engines = { '_' : '-xelatex' }
  let g:text_flavor='latex'
  let g:vimtex_view_method='zathura'
  let g:vimtex_quickfix_mode=0
  let g:tex_conceal='abdmg'
  set conceallevel=1
endfunction

function! bootstrap#after() abort
endfunction
