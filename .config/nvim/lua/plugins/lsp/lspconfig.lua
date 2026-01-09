return {{
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
        signature = { enabled = true },
        completion = {
            menu = {
                draw = {
                    columns = { { "label", "label_description", gap = 1 }, { "kind" } },
                },
            },
        },
    },
},
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "saghen/blink.cmp",
            { "folke/lazydev.nvim", config = true },
        },
        config = function()
            require("mason").setup()
            local lspconfig = require("lspconfig")
            local blink = require("blink.cmp")
            local capabilities = blink.get_lsp_capabilities()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls" },
                handlers = {
                    function(server_name)
                        lspconfig[server_name].setup({
                            capabilities = capabilities,
                        })
                    end,
                },
            })
        end,
    },
}
