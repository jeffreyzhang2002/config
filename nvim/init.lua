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
 
 vim.opt.number = true
 vim.opt.relativenumber = true
 vim.opt.tabstop = 4
 vim.opt.softtabstop = 4
 vim.opt.shiftwidth = 4
 vim.opt.expandtab = true
 
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
        {"airblade/vim-gitgutter"},
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
        {'neovim/nvim-lspconfig'},
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/nvim-cmp'},
        {'L3MON4D3/LuaSnip'},
        {'nvim-telescope/telescope.nvim', tag = '0.1.8', dependencies = {'nvim-lua/plenary.nvim'}},
        {"nvim-treesitter/nvim-treesitter"},
        {'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'},
        {'windwp/nvim-autopairs', event = "InsertEnter", config = true},
        {
            'Julian/lean.nvim',
            event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
            dependencies = {
                'neovim/nvim-lspconfig',
                'nvim-lua/plenary.nvim',
                'hrsh7th/nvim-cmp',
            },
            opts = {lsp = {}, mappings = true,}
        }
    },
    checker = { enabled = true },
 })
 
 require('telescope').setup {
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
 local lsp_setup = function(server, advanced)
   if (advanced) then
     require('lspconfig')[server].setup({
       capabilities =  require('cmp_nvim_lsp').default_capabilities()
     })
   else
     require('lspconfig')[server].setup({})
   end
 end
 
 local cmp = require('cmp')
 local cmp_autopairs = require('nvim-autopairs.completion.cmp')
 
 cmp.setup({
   sources = {
     {name = 'nvim_lsp'},
   },
   mapping = cmp.mapping.preset.insert({
     -- Enter key confirms completion item
     ['<CR>'] = cmp.mapping.confirm({select = false}),
 
     -- Ctrl + space triggers completion menu
     ['<C-Space>'] = cmp.mapping.complete(),
   }),
   snippet = {
     expand = function(args)
       require('luasnip').lsp_expand(args.body)
     end,
   },
 })
 
 cmp.event:on(
     'confirm_done',
     cmp_autopairs.on_confirm_done()
 )
 
 vim.keymap.set({"n"}, "<leader>/", vim.cmd.Ex)
 
 -- Quality Of Life Commands
 vim.keymap.set({"n"}, "<C-s>", vim.cmd.w)
 vim.keymap.set({"n"}, "<c-a>", "<ESC>ggVG")
 
 -- Tab Commands
 vim.keymap.set({"n"}, "<C-+>", function() vim.cmd.tabnew(); vim.cmd.Ex() end)
 vim.keymap.set({"n"}, "<C-->", vim.cmd.tabnew)
 vim.keymap.set({"n"}, "<C-Right>", vim.cmd.tabnext)
 vim.keymap.set({"n"}, "<C-Left>", vim.cmd.tabprevious)
 
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
 
 local telescope = require('telescope.builtin')
 vim.keymap.set('n', '<C-f>', telescope.live_grep)
 vim.keymap.set('n', '<C-e>', telescope.find_files)
 vim.keymap.set('n', '<A-f>', telescope.treesitter)
 vim.keymap.set('n', '<A-e>', telescope.lsp_references)
 vim.keymap.set('n', '<A-d>', telescope.diagnostics)
 
 
 
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
 
lsp_setup("rust_analyzer") 
lsp_setup("clangd")
lsp_setup("typst_lsp")
