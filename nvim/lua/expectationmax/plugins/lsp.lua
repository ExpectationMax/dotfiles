return {
    {"williamboman/mason.nvim", config=true},
    {"williamboman/mason-lspconfig.nvim", config=true},
    {"neovim/nvim-lspconfig"},
    {
        'tzachar/cmp-ai',
        dependencies = 'nvim-lua/plenary.nvim',
        config = function (plugin, opts) 
            local cmp_ai = require('cmp_ai.config')
            cmp_ai:setup({
              max_lines = 100,
              provider = 'Ollama',
              provider_options = {
                model = 'codellama:13b-python',
              },
              notify = true,
              notify_callback = function(msg)
                vim.notify(msg)
              end,
              -- run_on_every_keystroke = true,
              ignored_file_types = {
                -- default is not to ignore
                -- uncomment to ignore in lua:
                -- lua = true
              },
            })
        end
    },
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    {"L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp"},
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/nvim-cmp",
    "onsails/lspkind.nvim"
}
