return {
  -- https://www.reddit.com/r/NixOS/comments/1frzom3/lazyvim_distro_example/
  { "williamboman/mason-lspconfig.nvim", enabled = false },
  { "williamboman/mason.nvim",           enabled = false },
  { "LhKipp/nvim-nu" },
  -- For more lsp, see https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/server_configurations
  -- TODO: switch to nix-cats for simple config
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {},
        ruff = {},
        gopls = {},
        nil_ls = {},
        yamlls = {},
        ocamllsp = {},
        vtsls = {},
      },
    },
  },

}
