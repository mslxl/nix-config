local enable_lsp = {
  'clangd',
  'pylsp',
  'ltex',
  'hls',
  'metals',
  "rust_analyzer",
  'sumneko_lua',
  'cmake',
  'bashls',
  'jsonls',
  'yamlls'
  }

local lsp_installer_servers = require'nvim-lsp-installer.servers'

local function install_server(name, cpb)
  local server_available, requested_server = lsp_installer_servers.get_server(name)
  if server_available then
      requested_server:on_ready(function ()
          local opts = {
            capabilities = cpb
          }
          requested_server:setup(opts)
      end)
      if not requested_server:is_installed() then
          -- Queue the server to be installed
          requested_server:install()
      end
  end
end


-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.

local lspconf = require('lspconfig')
for i = 1, #enable_lsp do
  local name = enable_lsp[i]
  install_server(name, capabilities)
end
