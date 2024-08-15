vim.opt.expandtab = true
-- vim.opt.breakindent = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.wrap = true
-- vim.opt.cindent = true
vim.opt.number = true

vim.opt.termguicolors = true
-- Windows 側でクリップボードに入ったものは `p` でペーストできず、`i` で INSERT に入ってから Shift Ctrl V でペーストしなければならない
vim.opt.clipboard = 'unnamedplus'

vim.g.mapleader = ' '

-- https://github.com/nvim-tree/nvim-tree.lua#setup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Windows Terminal などによって持っていかれるのでムリ
-- vim.api.nvim_set_keymap('n', '<C-Tab>', ':bnext<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-S-Tab>', ':bprev<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<S-l>', ':bnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-h>', ':bprev<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<C-w>', ':bd<CR>', { noremap = true, silent = true })

-- trailing white space
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = [[%s/\s\+$//e]],
})

local function create_worklog(title)
  local year_month = os.date("%Y%m")
  local year_month_day = os.date("%Y%m%d")
  local dir = "worklog/" .. year_month .. "/" .. year_month_day .. "-" .. title
  vim.fn.mkdir(dir, "p")
  local file = dir .. "/README.md"
  vim.cmd("edit " .. file)
end
vim.api.nvim_create_user_command("CreateWorklog", function(opts)
  create_worklog(opts.args)
end, { nargs = 1 })

require("config.lazy")
