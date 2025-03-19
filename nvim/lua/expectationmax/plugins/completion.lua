return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        {
            "L3MON4D3/LuaSnip",
            build = "make install_jsregexp",
            dependencies = {
                {
                    "rafamadriz/friendly-snippets",
                    config = function()
                      require("luasnip.loaders.from_vscode").lazy_load()
                    end,
                },
            },
        },
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "onsails/lspkind.nvim"
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local lspkind = require("lspkind")
        luasnip.config.setup()

        cmp.setup({
            snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                  luasnip.lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = {
                ["<C-p>"] = cmp.mapping(function()
                    if cmp.visible() then
                        cmp.select_prev_item(cmp_select_opts)
                    else
                        cmp.complete()
                    end
                end),
                ["<C-n>"] = cmp.mapping(function()
                    if cmp.visible() then
                        cmp.select_next_item(cmp_select_opts)
                    else
                        cmp.complete()
                    end
                end),
                ["<C-y>"] = cmp.mapping.confirm({select = true}),
                ["<C-e>"] = cmp.mapping.close(),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                -- ["<CR>"] = cmp.mapping.confirm({
                --   select = false,
                --   behavior = cmp.ConfirmBehavior.Replace,
                -- }),
                ['<C-l>'] = cmp.mapping(function()
                    if luasnip.expand_or_locally_jumpable() then
                      luasnip.expand_or_jump()
                    end
                end, { 'i', 's' }),
                ['<C-h>'] = cmp.mapping(function()
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    end
                end, { 'i', 's' }),
            },
            sources = {
                { name = "nvim_lua" },
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "path" },
                { name = "nvim_lsp_signature_help" },
            },
            window = {
                documentation = {
                    max_height = 15,
                    max_width = 60,
                }
            },
            formatting = {
                fields = {'abbr', 'menu', 'kind'},
                format = lspkind.cmp_format()
            },
        })
    end,
}
