return {
  -- {
  --   'nvim-treesitter/nvim-treesitter-textobjects',
  --   -- dependencies = {"nvim-treesitter/nvim-treesitter"},
  -- },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy=false,
    dependencies = {
      {
        "abecodes/tabout.nvim",         -- Tab out from parenthesis, quotes, brackets...
        opts = {
          tabkey = "<Tab>",             -- key to trigger tabout, set to an empty string to disable
          backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
          completion = false,            -- We use tab for completion so set this to true
          ignore_beginning = true,
        },
      },
    },
  },
}
