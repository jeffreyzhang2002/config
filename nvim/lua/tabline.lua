vim.o.showtabline = 2

-- e0ba
-- e0b8

local LEFT_SEP = vim.fn.nr2char(0xe0b6) --vim.fn.nr2char(0xe0ba)
local RIGHT_SEP = vim.fn.nr2char(0xe0b4) --vim.fn.nr2char(0xe0b8)
local EXIT = vim.fn.nr2char(0xf00d)

Tabline = { }

function create_tab(i, cur_tab) 
    
    local buflist = vim.fn.tabpagebuflist(i)
    local number = vim.fn.tabpagewinnr(i)
    local bufname = vim.fn.fnamemodify(vim.fn.bufname(buflist[number]), ":t")
    
    if bufname == "" then
        bufname = i
    else
        bufname = i .. " " .. bufname
    end
    

    local color = i == cur_tab and "%#TablineSel#" or "%#Tabline#"
    local sep = i == cur_tab and "%#tab_sep_sel#" or "%#tab_sep#"

    return table.concat({
        "%", i, "T",
        sep,
        LEFT_SEP,
        color,
        "%0.20(",
        bufname,
        "%) ",
        "%", i, "X",
        EXIT,
        "%X",
        sep,
        RIGHT_SEP,
        "%T%#TablineFill#"
    })

end

Tabline.main = function() 

    local tabs = {}

    local num_tab = vim.fn.tabpagenr('$')
    local cur_tab = vim.fn.tabpagenr()

    for i = 1,num_tab do
        tabs[i] =  create_tab(i, cur_tab)
    end
    


    return table.concat(tabs)



end

vim.o.tabline = "%!v:lua.Tabline.main()"
