vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- vim.opt.smartindent = true

-- vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.colorcolumn = "80"

vim.opt.diffopt:append('vertical')

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Folds
vim.wo.foldcolumn = '0'
vim.wo.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.wo.foldenable = true

vim.diagnostic.config({
  severity_sort = true,
  underline = false,
  update_in_insert = true,
  virtual_text = false,
  float = { border = 'shadow' },
})
