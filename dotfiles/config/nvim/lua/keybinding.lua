vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.api.nvim_set_keymap
local opt = {noremap = true, silent = true}

map("n", "<C-p>", "9k", opt)
map("n", "<C-n>", "9j", opt)

map('v', '<', '<gv', opt)
map('v', '>', '>gv', opt)


map("n", "sv", ":vsp<CR>", opt)
map("n", "sh", ":sp<CR>", opt)
map("n", "sc", "<C-w>c", opt)
map("n", "so", "<C-w>o", opt) -- close others

map("n", "<A-h>", "<C-w>h", opt)
map("n", "<A-j>", "<C-w>j", opt)
map("n", "<A-k>", "<C-w>k", opt)
map("n", "<A-l>", "<C-w>l", opt)


-- nvim-tree
map('n', '<A-1>', ':NvimTreeToggle<CR>', opt)

-- bufferline tab switch
map('n', '<C-h>', ":BufferLineCyclePrev<CR>", opt)
map('n', '<C-l>', ":BufferLineCycleNext<CR>", opt)
