vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<leader>h", ":noh")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>Y", "\"+yy")
vim.keymap.del("n", "Y")

vim.keymap.set("n", "<leader>f", function()
    vim.cmd("Format")
end)
vim.keymap.set("n", "<leader>n", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>N", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<leader>w", "<C-w>")

vim.keymap.set("n", "<leader>d", vim.lsp.buf.hover)

