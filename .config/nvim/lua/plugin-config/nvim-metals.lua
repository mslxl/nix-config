local cmd = vim.cmd

cmp_cpb = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

cmd([[
  augroup lsp
    au!
    au FileType scala,sbt lua require("metals").initialize_or_attach({})
  augroup end
]])

cmp_cpb = nil

local metals_config = require("metals").bare_config()
metals_config.init_options.statusBarProvider = "on"
