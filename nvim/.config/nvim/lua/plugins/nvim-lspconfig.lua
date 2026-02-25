return {
  -- LSP Configuration
  -- https://github.com/neovim/nvim-lspconfig
  'neovim/nvim-lspconfig',
  event = 'VeryLazy',
  dependencies = {
    -- LSP Management
    -- https://github.com/williamboman/mason.nvim
    { 'williamboman/mason.nvim' },
    -- https://github.com/williamboman/mason-lspconfig.nvim
    { 'williamboman/mason-lspconfig.nvim' },

    -- Useful status updates for LSP
    -- https://github.com/j-hui/fidget.nvim
    { 'j-hui/fidget.nvim', opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing!
    -- https://github.com/folke/neodev.nvim
    { 'folke/neodev.nvim', opts = {} },
  },
  config = function ()
    require('mason').setup()
    local mason_lspconfig = require('mason-lspconfig')

    mason_lspconfig.setup({
      ensure_installed = {
        'angularls',
        'ansiblels',
        'astro',
        'bashls',
        'cssls',
        'docker_compose_language_service',
        'dockerls',
        'html',
        'jsonls',
        'lua_ls',
        'marksman',
        'quick_lint_js',
        'svelte',
        'tailwindcss',
        'ts_ls',
        'vimls',
        'yamlls'
      }
    })

    local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
    local lsp_attach = function(client, bufnr)
      -- Create your keybindings here...
    end

    -- Default setup configuration
    local default_config = {
      capabilities = lsp_capabilities,
      on_attach = lsp_attach,
    }

    -- Setup all servers explicitly using new API
    local servers = {
      'angularls',
      'ansiblels',
      'astro',
      'bashls',
      'cssls',
      'docker_compose_language_service',
      'dockerls',
      'html',
      'jsonls',
      'marksman',
      'quick_lint_js',
      'svelte',
      'tailwindcss',
      'ts_ls',
      'vimls',
      'yamlls'
    }

    -- Configure each server with default config
    for _, server in ipairs(servers) do
      vim.lsp.config(server, default_config)
    end

    -- lua_ls with special configuration
    vim.lsp.config('lua_ls', {
      capabilities = lsp_capabilities,
      on_attach = lsp_attach,
      settings = {
        Lua = {
          diagnostics = {
            globals = {'vim'},
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
        },
      },
    })

    -- Enable each server individually
    for _, server in ipairs(servers) do
      vim.lsp.enable(server)
    end
    vim.lsp.enable('lua_ls')

    -- Globally configure all LSP floating preview popups (like hover, signature help, etc)
    local open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or "rounded" -- Set border to rounded
      return open_floating_preview(contents, syntax, opts, ...)
    end
  end
}
