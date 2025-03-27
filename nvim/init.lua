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
vim.opt.scrolloff = w
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
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate"
        },
        {
            "catppuccin/nvim",
            name = "catppuccin",
            priority = 1000,
            config = function()
                vim.cmd.colorscheme "catppuccin"
            end
        },
        {
            "folke/snacks.nvim",
            priority = 1000,
            lazy = false,
            opts = {
                bigfile = { enabled = true },
                dashboard = { enabled = true },
                explorer = { enabled = true },
                indent = { enabled = true },
                input = { enabled = true },
                picker = { enabled = true },
                notifier = { enabled = true },
                quickfile = { enabled = true },
                scope = { enabled = true },
                scroll = { enabled = false },
                statuscolumn = { 
                    enabled = true, 
                    left = { "mark", "sign" }, -- priority of signs on the left (high to low)
                    right = { "fold", "git" }, -- priority of signs on the right (high to low)
                    folds = {
                        open = false, -- show open fold icons
                        git_hl = false, -- use Git Signs hl for fold icons
                    },
                    git = {
                        -- patterns to match Git signs
                        patterns = { "GitSign", "MiniDiffSign" },
                    },
                    refresh = 500, -- refresh at most every 50ms
                },
                words = { enabled = true },
                image = { enabled = false},
                lazygit = {enabled = false}
            },
            keys = {
                -- Top Pickers & Explorer
                { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
                { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
                { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
                { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
                { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
                -- find
                { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
                { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
                { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
                { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
                { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
                -- git
                { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
                { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
                { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
                { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
                { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
                { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
                { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
                -- Grep
                { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
                { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
                { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
                { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
                -- search
                { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
                { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
                { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
                { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
                { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
                { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
                { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
                -- { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
                -- { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
                -- { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
                -- { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
                -- { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
                -- { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
                -- { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
                -- { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
                -- { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
                -- { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
                -- { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
                -- { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
                -- { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
                -- LSP
                { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
                { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
                { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
                { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
                { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
                { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
                { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
                -- Other
                -- { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
                -- { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
                -- { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
                -- { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
                -- { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
                -- { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
                -- { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
                -- { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
                -- { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
                -- { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
                { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
                { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
                { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
                { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
            }
          },
        {
            'nvim-lualine/lualine.nvim',
            dependencies = {'nvim-tree/nvim-web-devicons'},
            config = function()
                require('lualine').setup()
            end
        },
        {
            'whonore/Coqtail',
            event = { 'BufReadPre *.v', 'BufNewFile *.v'},
            init = function()
                vim.g.coqtail_nomap=1 
                vim.g.coqtail_noimap=1
                vim.keymap.set({"n"}, "<C-Down>", ":CoqNext")
            end,
        },
        {
            'Julian/lean.nvim',
            event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },

            dependencies = {
                'neovim/nvim-lspconfig',
                'nvim-lua/plenary.nvim',
            },
            opts = { 
                mappings = true,
            }
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
                    list = { selection = {
                        preselect = false,
                        auto_insert = true
                    }},
                },
            },
            signature = { enabled = true }
        },
    },
    checker = { enabled = true },
})

-- Enable Lsp for some language
local lsp_setup = function(server, capabilities)
    require('lspconfig')[server].setup({capabilities = capabilities})
end

Snacks.toggle.option("spell", { name = "Spelling" }):map("<M-s>")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<M-z>")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<M-l>")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<C-L>")

-- Quality Of Life Commands
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

local capabilities = require('blink.cmp').get_lsp_capabilities()

lsp_setup("rust_analyzer", capabilities) 
lsp_setup("clangd", capabilities)
lsp_setup("pylsp",  capabilities)
lsp_setup("tinymist",  capabilities)
