local Mode = {
  ['n']      = {name='NORMAL',    color="n"},
  ['no']     = {name='O-PENDING', color="n"},
  ['nov']    = {name='O-PENDING', color="n"},
  ['noV']    = {name='O-PENDING', color="n"},
  ['no\22']  = {name='O-PENDING', color="n"},
  ['niI']    = {name='NORMAL',    color="n"},
  ['niR']    = {name='NORMAL',    color="n"},
  ['niV']    = {name='NORMAL',    color="n"},
  ['nt']     = {name='NORMAL',    color="n"},
  ['ntT']    = {name='NORMAL',    color="n"},
  ['v']      = {name='VISUAL',    color="v"},
  ['vs']     = {name='VISUAL',    color="v"},
  ['V']      = {name='V-LINE',    color="v"},
  ['Vs']     = {name='V-LINE',    color="v"},
  ['\22']    = {name='V-BLOCK',   color="v"},
  ['\22s']   = {name='V-BLOCK',   color="v"},
  ['s']      = {name='SELECT',    color="o"},
  ['S']      = {name='S-LINE',    color="o"},
  ['\19']    = {name='S-BLOCK',   color="o"},
  ['i']      = {name='INSERT',    color="i"},
  ['ic']     = {name='INSERT',    color="i"},
  ['ix']     = {name='INSERT',    color="i"},
  ['R']      = {name='REPLACE',   color="r"},
  ['Rc']     = {name='REPLACE',   color="r"},
  ['Rx']     = {name='REPLACE',   color="r"},
  ['Rv']     = {name='V-REPLACE', color="r"},
  ['Rvc']    = {name='V-REPLACE', color="r"},
  ['Rvx']    = {name='V-REPLACE', color="r"},
  ['c']      = {name='COMMAND',   color="t"},
  ['cv']     = {name='EX',        color="t"},
  ['ce']     = {name='EX',        color="t"},
  ['r']      = {name='REPLACE',   color="t"},
  ['rm']     = {name='MORE',      color="t"},
  ['r?']     = {name='CONFIRM',   color="t"},
  ['!']      = {name='SHELL',     color="t"},
  ['t']      = {name='TERMINAL',  color="t"}
}

local RIGHT_ARROW = vim.fn.nr2char(0xe0b0)
local RIGHT_SPLIT = vim.fn.nr2char(0xe0b1)
local LEFT_ARROW = vim.fn.nr2char(0xe0b2)
local LEFT_SPLIT = vim.fn.nr2char(0xe0b3)

local ERROR_SYM = vim.fn.nr2char(0xf05c)
local WARN_SYM = vim.fn.nr2char(0xea6c)

Statusline = {}

function Name(a, b, c, d) 
    print(vim.fn.expand('%:p:~'))
end

Statusline.active = function()

    local mode = Mode[vim.api.nvim_get_mode().mode]
    local color_a = "%#status_" .. mode.color .. "_a#"
    local color_s = "%#status_" .. mode.color .. "_s#"
    local modename = " " .. mode.name .. " "

    -- local num_errors = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.ERROR}) + 1
    -- local num_warns = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.WARN}) + 1
    --
    -- local error_info = (num_errors > 0) and ERROR_SYM .. " " .. num_errors or ""
    -- local warn_info = (num_warns > 0) and WARN_SYM .. " " .. num_warns or ""

    return table.concat {
        "%-30.30(",
        color_a, 
        modename,
        color_s,
        RIGHT_ARROW,
        "%#StatusLine#",
        " %@v:lua.Name@%t%X %m ",
        "%)",
        "%=",
        "%<", 
        "%=",
        "%<",
        "%30.30(",
        " %p%% ",
        color_s,
        LEFT_ARROW,
        color_a,
        " %l:%L ",
        "%)"
    }
end

Statusline.inactive = function()

    return table.concat {
        "%#StatusLine#",
        "%t %m",
        "%=%<",
        "%p%% %l:%L "
        
    }
end

local group = vim.api.nvim_create_augroup("statusline", {clear = true})

vim.api.nvim_create_autocmd({"WinEnter", "BufEnter"}, {
    group = group,
    callback = function()
        vim.opt_local.statusline = "%!v:lua.Statusline.active()"
    end,
})

vim.api.nvim_create_autocmd({"WinLeave", "BufLeave"}, {
    group = group,
    callback = function()
        vim.opt_local.statusline = "%!v:lua.Statusline.inactive()"
    end,
})

