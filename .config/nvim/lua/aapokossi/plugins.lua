 -- vim.cmd [[packadd packer.nvim]]
 --
 -- return require('packer').startup(function(use)
 --   -- Packer can manage itself
 --   use 'wbthomason/packer.nvim'
 --   use 'mbbill/undotree'
 --   use {
 --     'nvim-treesitter/nvim-treesitter',
 --     run = function()
 --       local ts_update = require('nvim-treesitter.install').update({with_sync = true })
 --       ts_update()
 --     end,
 --   }
 --   use({
 --     'shaunsingh/nord.nvim',
 --     as = 'nord',
 --     config = function()
 --       vim.cmd('colorscheme nord')
 --     end
 --   })
 --   use {
 --     'VonHeikemen/lsp-zero.nvim',
 --     branch = 'v3.x',
 --     requires = {
 --       -- LSP Support
 --       {'neovim/nvim-lspconfig'},             -- Required
 --       {'williamboman/mason.nvim'},           -- Optional
 --       {'williamboman/mason-lspconfig.nvim'}, -- Optional
 --
 --       -- Autocompletion
 --       {'hrsh7th/nvim-cmp'},     -- Required
 --       {'hrsh7th/cmp-nvim-lsp'}, -- Required
 --       {'L3MON4D3/LuaSnip'},     -- Required
 --     }
 --   }
 --   use "mhartington/formatter.nvim"
 -- end)

-- Ensure lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

-- Plugin: undotree
   { 'mbbill/undotree' },

   {
     "nvim-treesitter/nvim-treesitter",
     build = ":TSUpdate",
     config = function ()
       local configs = require("nvim-treesitter.configs")

       configs.setup({
           ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
           sync_install = false,
           highlight = { enable = true },
           indent = { enable = true },
         })
       end
   },

   -- Plugin: tokyonight with configuration
   {
     'folke/tokyonight.nvim',
     lazy = false,
     priority = 1000,
     name = 'tokyonight',
     opts = {
       style = "night",
       transparent = true,
       styles = {
         sidebars = "transparent",
         floats = "transparent",
       },
       on_colors = function(colors)
         colors.bg_statusline = colors.none
         colors.comment = "#b595af"
       end,
     },
   },

  -- Plugin: lualine
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      theme = 'tokyonight',
      sections = {
        lualine_x = {'filetype'},
        lualine_y = {'location'},
        lualine_z = {''},
      },
    },
  },

  -- Plugin: markdown previewing
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  -- Plugin: Git integration
  { "tpope/vim-fugitive" },

  -- Plugin: lsp-zero with dependencies
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      { 'neovim/nvim-lspconfig' },             -- Required
      { 'williamboman/mason.nvim' },           -- Optional
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },     -- Required
      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
      { 'L3MON4D3/LuaSnip' },     -- Required
    }
  },

  -- Plugin: formatter.nvim
  { 'mhartington/formatter.nvim' },
  {
    'folke/trouble.nvim',
    opts = {},
    cmd = "Trouble",
    lazy = false,
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  }
})

