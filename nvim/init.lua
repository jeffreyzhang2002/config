-- Bootstrap lazy.nvim
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
vim.g.maplocalleader = "\\"
vim.g.netrw_liststyle=3
vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
        ["+"] = "win32yank.exe -i --crlf",
        ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
        ["+"] = "win32yank.exe -o --lf",
        ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = true,
}

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.whichwrap = "<,>,h,l,[,]"

vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.keymodel="startsel"

-- Automatic Fold Setup
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 1
vim.opt.foldnestmax = 4

-- Tabline
vim.opt.showtabline = 2

-- Live preview
vim.inccommand="nosplit"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        {
            "catppuccin/nvim",
            name = "catppuccin",
            priority = 1000,
            config = function()
                vim.cmd.colorscheme "catppuccin"
            end
        },
        {
            'goolord/alpha-nvim',
            config = function ()
                require'alpha'.setup(require'alpha.themes.dashboard'.config)
            end
        },
        {
            'nvim-lualine/lualine.nvim',
            dependencies = {'nvim-tree/nvim-web-devicons'},
            config = function()
                require('lualine').setup()
            end
        },
        {
            'lewis6991/gitsigns.nvim'
        },
        {'neovim/nvim-lspconfig'},
        {
            'saghen/blink.cmp',
            version = '*',
            opts = {
                keymap = { preset = 'enter' },
                sources = {
                    default = {'lsp', 'path', 'snippets', 'buffer'},
                },
                completion = {
                    list = { selection = "auto_insert" },
                }
            }
        },
        {'nvim-telescope/telescope.nvim', tag = '0.1.8', dependencies = {'nvim-lua/plenary.nvim'}},
        {"nvim-treesitter/nvim-treesitter"},
        {'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'},
    },
    checker = { enabled = true },
})

local telescope_actions = require("telescope.actions")

require("gitsigns").setup()
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = telescope_actions.close
            }
        }
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        }
    }
}

-- Enable Lsp for some language
local lsp_setup = function(server, capabilities)
    require('lspconfig')[server].setup({capabilities = capabilities})
end

-- Open file explorer
vim.keymap.set({"n"}, "<leader>/", vim.cmd.Ex)

-- Quality Of Life Commands
vim.keymap.set({"n"}, "<C-s>", vim.cmd.w)
vim.keymap.set({"n"}, "<c-a>", "<ESC>ggVG")

-- Change movement to allow for word wrap
vim.keymap.set({"n"}, "<Up>", "gk")
vim.keymap.set({"n"}, "<Down>", "gj")
vim.keymap.set({"i"}, "<Up>", "<C-O>gk")
vim.keymap.set({"i"}, "<Down>", "<C-O>gj")

-- Tab Commands
vim.keymap.set({"n"}, "<C-+>", function() vim.cmd.tabnew(); vim.cmd.Ex() end)
vim.keymap.set({"n"}, "<C-->", vim.cmd.tabnew)
vim.keymap.set({"n"}, "<C-Right>", vim.cmd.tabnext)
vim.keymap.set({"n"}, "<C-Left>", vim.cmd.tabprevious)
vim.keymap.set({"n"}, "<A-1>", "1gt")
vim.keymap.set({"n"}, "<A-2>", "2gt")
vim.keymap.set({"n"}, "<A-3>", "3gt")
vim.keymap.set({"n"}, "<A-4>", "4gt")
vim.keymap.set({"n"}, "<A-5>", "5gt")
vim.keymap.set({"n"}, "<A-6>", "6gt")
vim.keymap.set({"n"}, "<A-7>", "7gt")
vim.keymap.set({"n"}, "<A-8>", "8gt")
vim.keymap.set({"n"}, "<A-9>", "9gt")
vim.keymap.set({"n"}, "<A-0>", ":tablest<cr>")

-- Line Numbers and Wrapping
vim.keymap.set("n", "<c-l>", ":set relativenumber!<cr>")
vim.keymap.set("n", "<a-z>", ":set wrap!<cr>")

-- Windowing Commands
vim.keymap.set({"n"}, "<C-Space>-", "<c-w>s")
vim.keymap.set({"n"}, "<C-Space>|", "<c-w>v")
vim.keymap.set({"n"}, "<C-Space>,", "<c-w><")
vim.keymap.set({"n"}, "<C-SPace>.", "<c-w>>")
vim.keymap.set({"n"}, "<C-Space>h", "<c-w><")
vim.keymap.set({"n"}, "<C-Space>l", "<c-w>>")
vim.keymap.set({"n"}, "<C-Space>k", "<c-w>-")
vim.keymap.set({"n"}, "<C-Space>j", "<c-w>+")
vim.keymap.set({"n"}, "<C-Space><Right>", "<c-w><Right>")
vim.keymap.set({"n"}, "<C-Space><Left>", "<c-w><Left>")

-- Diagnostics Commands
vim.keymap.set({'n'}, '<leader>do', vim.diagnostic.open_float)
vim.keymap.set({'n'}, '<leader>d[', vim.diagnostic.goto_prev)
vim.keymap.set({'n'}, '<leader>d]', vim.diagnostic.goto_next)

-- Disable Line numberings for terminals
vim.keymap.set({'t'}, '<Esc>', '<C-\\><C-n>')
vim.api.nvim_command("autocmd TermOpen * startinsert")
vim.api.nvim_command("autocmd TermOpen * setlocal nonumber")
vim.api.nvim_command("autocmd TermOpen * setlocal norelativenumber")
vim.api.nvim_command("autocmd TermEnter * setlocal signcolumn=no")

-- Telescope Commands
local telescope = require('telescope.builtin')
vim.keymap.set({'n', 'i'}, '<C-f>', telescope.live_grep)
vim.keymap.set({'n', 'i'}, '<C-e>', telescope.find_files)
vim.keymap.set({'n', 'i'}, '<A-f>', telescope.treesitter)
vim.keymap.set({'n', 'i'}, '<A-e>', telescope.lsp_references)
vim.keymap.set({'n', 'i'}, '<A-d>', telescope.diagnostics)

-- Commenting Commands
vim.keymap.set('n', '<C-//>', 'gcc')
vim.keymap.set('i', '<C-//>', '<c-o>gcc')

-- LSP commands
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = {buffer = event.buf}

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<C-r>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    end
})

-- File type specific information

local capabilities = require('blink.cmp').get_lsp_capabilities()

lsp_setup("rust_analyzer", capabilities) 
lsp_setup("clangd", capabilities)
lsp_setup("pylsp",  capabilities)
lsp_setup("tinymist",  capabilities)
