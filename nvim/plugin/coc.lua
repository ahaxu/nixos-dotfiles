local function check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }

vim.keymap.set("i", "<C-j>",
    function()
        if vim.fn['coc#pum#visible']() == 1 then
            return vim.fn['coc#pum#next'](1)
        end
        if check_back_space() then
            return vim.fn['coc#refresh']()
        end
    end
    , opts
)
vim.keymap.set("i", "<C-S-j>",
    function()
        if vim.fn['coc#pum#visible']() == 1 then
            return vim.fn['coc#pum#prev'](1)
        end
    end
    ,opts
)
vim.keymap.set("i", "<CR>",
    function()
        if vim.fn['coc#pum#visible']() == 1 then
            return vim.fn['coc#pum#confirm']();
        end
        return "\r"
    end
    , opts
)

