local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.o.number = true
vim.o.signcolumn = "yes"
vim.o.wrap = true

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = false

vim.o.swapfile = false
vim.o.backup = false
vim.opt.clipboard:append("unnamedplus")

vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

vim.keymap.set("v", "p", '"_dp')
vim.keymap.set("v", "P", '"_dP')

vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

require("lazy").setup({
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true
    },
    {
        "ficcdaf/ashen.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme ashen")
            vim.api.nvim_set_hl(0, "Normal", { bg = "#000000"})
            vim.api.nvim_set_hl(0, "LineNr", { bg = "#000000", fg = "#747474"})
            vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#DF6464"})
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        lazy = false,
        build = ":TSUpdate",
        config = function ()
            local ts = require("nvim-treesitter")
            if ts.install then
                ts.install({ "c" })
            end
            require("nvim-treesitter.configs").setup({
                highlight = { enable = true }
            })
        end
    },
    {
        "mikavilpas/yazi.nvim",
        event = "VeryLazy",
        dependencies = {
            { "nvim-lua/plenary.nvim", lazy = true },
        },
        keys = {
            {
                "<leader>-",
                mode = { "n", "v" },
                "<cmd>Yazi<cr>",
                desc = "Open yazi at the current file",
            },
            {
                "<leader>cw",
                "<cmd>Yazi cwd<cr>",
                desc = "Open the file manager in nvim's working directory",
            },
            {
                "<c-up>",
                "<cmd>Yazi toggle<cr>",
                desc = "Resume the last yazi session",
            },
        },
        opts = {
            open_for_directories = true,
            keymaps = {
                show_help = "<f1>",
            },
        },
        init = function()
            vim.g.loaded_netrw = true
            vim.g.loaded_netrwPlugin = true
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "saghen/blink.cmp",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({
                            capabilities = require("blink.cmp").get_lsp_capabilities()
                        })
                    end,
                },
            })
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local opts = { buffer = args.buf }
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set("n", "<leader>D", vim.diagnostic.setqflist, opts)
                    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
                    vim.keymap.set("n", "<space>wd", vim.lsp.buf.document_symbol, opts)
                end,
            })
        end,
    },
    {
        "saghen/blink.cmp",
        version = "1.*",
        opts = {
            signature = {
                enabled = true
            },
        },
    },
})
