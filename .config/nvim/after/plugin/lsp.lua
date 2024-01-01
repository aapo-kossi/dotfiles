local lsp_zero = require('lsp-zero').preset({
    manage_nvim_cmp = {
        set_extra_mappings = true,
    }
})

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

-- Make sure you setup `cmp` after lsp-zero

local cmp = require('cmp')

cmp.setup({
  preselect = 'item',
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  mapping = {
    ['<Tab>'] = cmp.mapping.confirm({select = false}),
    ['<C-j>'] = cmp.mapping.select_next_item({behavior = 'select'}),
    ['<C-k>'] = cmp.mapping.select_prev_item({behavior = 'select'}),

  },
})
require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {
		"pyright",
	},
	handlers = {
		lsp_zero.default_setup,
	},
})

require("formatter").setup {
    filetype = {
        python = {
            require("formatter.filetypes.python").black
        }
    }
}
