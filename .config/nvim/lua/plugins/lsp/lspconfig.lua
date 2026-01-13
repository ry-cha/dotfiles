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
        keymap = {
            ['<C-p>'] = false,
            ['<C-n>'] = false,
            ['<C-k>'] = { 'select_prev', 'fallback_to_mappings' },
            ['<C-j>'] = { 'select_next', 'fallback_to_mappings' },
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

                vim.api.nvim_create_autocmd("LspAttach", {
                    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                    callback = function(ev)
                        vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", {
                            buffer = ev.buf, silent = true, desc = "Show LSP references"
                        })
                        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {
                            buffer = ev.buf, silent = true, desc = "Go to declaration"
                        })
                        vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", {
                            buffer = ev.buf, silent = true, desc = "Show LSP definitions"
                        })
                        vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", {
                            buffer = ev.buf, silent = true, desc = "Show LSP implementations"
                        })
                        vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", {
                            buffer = ev.buf, silent = true, desc = "Show LSP type definitions"
                        })
                        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {
                            buffer = ev.buf, silent = true, desc = "See available code actions"
                        })
                        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {
                            buffer = ev.buf, silent = true, desc = "Smart rename"
                        })
                        vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", {
                            buffer = ev.buf, silent = true, desc = "Show buffer diagnostics"
                        })
                        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {
                            buffer = ev.buf, silent = true, desc = "Show line diagnostics"
                        })
                        vim.keymap.set("n", "K", vim.lsp.buf.hover, {
                            buffer = ev.buf, silent = true, desc = "Show documentation for what is under cursor"
                        })
                        vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", {
                            buffer = ev.buf, silent = true, desc = "Restart LSP"
                        })
                    end,
                })
            })
        end,
    },
}
