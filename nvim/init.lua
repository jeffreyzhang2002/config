
vim.g.mapleader = " "

vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.health = {style = "float"}

-- Color Scheme
vim.cmd [[colorscheme catpuccin]]


-- Options
vim.o.autoread = true
vim.o.backspace = "indent,eol,start,nostop"
vim.o.whichwrap = "<,>,h,l,[,]"
vim.o.winborder = "rounded"
vim.o.showmode = false
vim.o.guicursor = "n-i-ci-ve:ver25,v-c-sm:block,r-cr-o:hor20"

-- Search
vim.o.incsearch = true
vim.o.inccommand = "nosplit"

-- Line Numbering
vim.o.number = true
vim.o.relativenumber = true

-- Tabbing
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.softtabstop= 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

-- Line wrap
vim.o.wrap = true
vim.o.linebreak = true

-- Folding
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldtext = ""
vim.o.fillchars = "fold: ,foldopen:▾,foldclose:▸"
vim.o.foldlevelstart = 2
vim.o.foldnestmax = 4
vim.o.foldcolumn="auto:9"

-- Scrolling
vim.o.scrolloff = 5

-- Status Line
vim.o.laststatus = 2
require("statusline")

-- Tab Line
vim.o.showtabline = 1
require("tabline")

-- Custom Keymaps
vim.keymap.set("n", "<S-Right>", "v<Right>", {noremap = true})
vim.keymap.set("n", "<S-Left>", "v<Left>", {noremap = true})
vim.keymap.set("n", "<S-Up>", "v<Up>", {noremap = true})
vim.keymap.set("n", "<S-Down>", "v<Down>", {noremap = true})

vim.keymap.set({"n", "i"}, "<M-Up>", vim.cmd.bprevious, {noremap=true})
vim.keymap.set({"n", "i"}, "<M-Down>", vim.cmd.bnext, {noremap=true})
vim.keymap.set({"n", "i"}, "<M-Right>", vim.cmd.tabnext, {noremap=true})
vim.keymap.set({"n", "i"}, "<M-Left>", vim.cmd.tabprevious, {noremap=true})


vim.keymap.set({"n"}, "<Up>", "gk", {noremap=true, silent=true})
vim.keymap.set({"n"}, "<Down>", "gj", {noremap=true, silent=true})

-- LSP

vim.lsp.enable('lua_ls')
vim.lsp.enable('rust_analyzer')

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.opt.completeopt = {'menu', 'menuone', 'noinsert', 'fuzzy', 'popup'}
			vim.lsp.completion.enable(true, client.id, ev.buf, {autotrigger = true})
		end
	end,
})

vim.lsp.inlay_hint.enable(true)

vim.diagnostic.config({
    update_in_insert = true,
    virtual_text = {
        enable = true
    }
})
