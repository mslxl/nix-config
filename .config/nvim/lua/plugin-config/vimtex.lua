vim.g.tex_flavor='latex'
vim.g.vimtex_view_method='zathura'
vim.g.vimtex_quickfix_mode=1
vim.g.vimtex_compiler_latexmk_engines = {
  ['_'] = "-xelatex"
}
vim.g.vimtex_compiler_latexrun_engines = {
  ['_'] = "xelatex"
}
vim.wo.conceallevel = 1
vim.cmd("syntax on")
-- vim.g.tex_conceal='abdmg'
