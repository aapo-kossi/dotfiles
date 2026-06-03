return {
  -- Buffer Navigation
  {
    itemgroup = "Buffer Navigation",
    description = "Keymaps for navigating buffers and files",
    keymaps = {
      {
        "<leader>e",
        vim.cmd.Ex,
        description = "Open file explorer",
        mode = "n",
      },
    },
  },

  -- Cursor Movement (Centering)
  {
    itemgroup = "Cursor Movement",
    description = "Keymaps to help recenter the cursor after movement",
    keymaps = {
      {
        "<C-d>",
        "<C-d>zz",
        description = "Page down and center cursor",
        mode = "n",
      },
      {
        "<C-u>",
        "<C-u>zz",
        description = "Page up and center cursor",
        mode = "n",
      },
    },
  },

  -- Search Navigation
  {
    itemgroup = "Search & Navigation",
    description = "Keymaps for navigating search results and clearing highlights",
    keymaps = {
      {
        "n",
        "nzzzv",
        description = "Next search match, center, show surrounding text",
        mode = "n",
      },
      {
        "N",
        "Nzzzv",
        description = "Previous search match, center, show surrounding text",
        mode = "n",
      },
      {
        "<leader>h",
        ":noh<CR>",
        description = "Clear search highlights",
        mode = "n",
      },
    },
  },

  -- Copy & Paste
  {
    itemgroup = "Copy, Cut & Paste",
    description = "Keymaps for system clipboard integration and paste without yank",
    keymaps = {
      {
        "<leader>y",
        '"+y',
        description = "Yank to system clipboard",
        mode = { "n", "v" },
      },
      {
        "<leader>Y",
        '"+yy',
        description = "Yank linewise to system clipboard (Visual)",
        mode = "v",
      },
      {
        "<leader>p",
        '"_dP',
        description = "Paste without yanking over cut text",
        mode = "v",
      },
    },
  },

  -- Diagnostics
  {
    itemgroup = "LSP Diagnostics",
    description = "Keymaps for navigating and showing LSP diagnostics",
    keymaps = {
      {
        "<leader>n",
        function()
          vim.diagnostic.jump({ count = 1, on_jump = function() vim.diagnostic.open_float({ scope = 'c' }) end, })
        end,
        description = "Go to next diagnostic",
        mode = "n",
      },
      {
        "<leader>N",
        function()
          vim.diagnostic.jump({ count = -1, on_jump = function() vim.diagnostic.open_float({ scope = 'c' }) end, })
        end,
        description = "Go to previous diagnostic",
        mode = "n",
      },
    },
  },

  -- Window Management
  {
    itemgroup = "Window Management",
    description = "Start window command sequence (<C-w>). Common for <leader>w w, <leader>w s, <leader>w v etc.",
    keymaps = {
      {
        "<leader>w",
        "<C-w>",
        description = "Start window command sequence (<C-w>)",
        mode = "n",
      },
    },
  },
}
