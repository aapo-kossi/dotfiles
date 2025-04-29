return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      -- "nvim-treesitter/nvim-treesitter-textobjects", -- Syntax aware text-objects, select, move, swap, and peek support.

      {
        "JoosepAlviste/nvim-ts-context-commentstring", -- Smart commenting in multi language files - Enabled in Treesitter file
        config = true,
      },
      {
        "abecodes/tabout.nvim", -- Tab out from parenthesis, quotes, brackets...
        opts = {
          tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
          backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
          completion = true, -- We use tab for completion so set this to true
        },
      },
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        sycn_install = false,
        ensure_installed = { "c", "lua", "vim", "vimdoc", "python" },
        ignore_install = { "phpdoc", "javascript", "typescript" },
        highlight = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<leader>s",
            scope_incremental = "<CR>", -- increment to enclosing scope
            node_incremental = "<Tab>", -- increment to upper named parent
            node_decremental = "<BS>", -- decrement to previous node
          },
        },
        indent = { enable = true },

        -- textobjects = {
        --   select = {
        --     enable = true,
        --     lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        --
        --     keymaps = {
        --       -- Use v[keymap], c[keymap], d[keymap] to perform any operation
        --       ["af"] = "@function.outer",
        --       ["if"] = "@function.inner",
        --       ["ac"] = "@class.outer",
        --     },
        --   },
        -- },
      })
    end,
  },
}
