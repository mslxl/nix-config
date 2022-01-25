require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "html", "css", "javascript", "typescript", "tsx", "pug",
    "cpp", "c","cmake",
    "rust",
    "bash",
    "lua",
    "haskell",
    "python",
    "java", "kotlin",
    "jsdoc", "json",
    "latex",
    "python",
    "regex",
    "scala",
    "toml",
    "yaml"
  },

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      node_incremental = '<CR>',
      node_decremental = '<BS>',
      scope_incremental = '<TAB>',
    }
  },
  indent = {
    enable = true
  }
}

vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

vim.wo.foldlevel = 99
