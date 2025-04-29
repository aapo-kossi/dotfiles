return {

  -- tokyonight color scheme
  {
    'folke/tokyonight.nvim',
    name = 'tokyonight',
    lazy = false,
    priority = 1000,
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

  -- lualine
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

}
