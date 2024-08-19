--
-- neovim options 2022
--

-- enable mouse in all modes
vim.opt.mouse = 'a'

-- show line numbers
vim.opt.number = true

-- tabs to spaces
vim.opt.expandtab = true

-- sane indentation
local tabstop = 2
vim.opt.tabstop = tabstop
vim.opt.shiftwidth = tabstop
vim.opt.softtabstop = tabstop

-- ignore case when searching
vim.opt.ignorecase = true

-- global substitute default on
vim.opt.gdefault = true

-- highlight matching bracket
vim.opt.showmatch = true

-- disable line wrapping
vim.opt.wrap = false

-- autoread files changed outside vim
vim.opt.autoread = true

-- write files when moving around file lists
vim.opt.autowrite = true
vim.opt.autowriteall = true

-- always show sign column
vim.opt.signcolumn = "yes"

-- use ripgrep for :grep
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"

-- show color column
vim.opt.textwidth = 100
vim.opt.colorcolumn = "101"
vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg=7, bg="#111111" })
