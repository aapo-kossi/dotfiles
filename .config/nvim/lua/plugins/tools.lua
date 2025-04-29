return {

  -- Plugin: undotree
  {
    'mbbill/undotree',
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle undo tree" }
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

  -- Plugin: automatic tabstop
  "tpope/vim-sleuth",
  {
    "echasnovski/mini.diff",
    config = function()
      local diff = require("mini.diff")
      diff.setup({
        -- Disabled by default
        source = diff.gen_source.none(),
      })
    end,
  },

  -- Plugin: keymap management
  {
    "mrjones2014/legendary.nvim",
    lazy = false,
    priority = 10000,
    init = function()
      local keys = require("config.keymaps")
      local cmds = require("config.commands")
      require("legendary").setup({
        keymaps = keys,
        commands = cmds.commands,
        autocmds = cmds.autocmds,
        extensions = { lazy_nvim = true, }
      })
    end,
  },

  -- Plugin: todo viewing and highlights
  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>tt",
        "<cmd>Trouble todo<CR>",
        desc = "List all project todos using Trouble"
      },
    },
    opts = {},
  },

  -- Plugin: better comments
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  },

  -- Plugin: progress windows?
  {
    "j-hui/fidget.nvim",
    cmd = { "Fidget history" },
    event = { "VeryLazy" },
  },

  -- Plugin: slop :)
  {
    "olimorris/codecompanion.nvim",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "echasnovski/mini.diff",
        config = function()
          local diff = require("mini.diff")
          diff.setup({
            -- Disabled by default
            source = diff.gen_source.none(),
          })
        end,
      },
    },
    cmd = {
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanion",
      "CodeCompanionCmd"
    },
    keys = {
      {
        "<leader>l",
        nil,
        description = "Open the action palette",
        mode = { "n", "v" },
      },
    },
    opts = {
      adapters = {
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            schema = {
              model = {
                default = "gemini-2.5-flash-preview-04-17",
              },
            },
          })
        end
      },
      strategies = {
        chat = {
          adapter = "gemini",
          opts = {
            schema = {
              model = {
                default = "gemini-2.5-pro-preview-03-25",
              },
            },
          },
        },
        inline = {
          adapter = "gemini",
        },
        cmd = {
          adapter = "gemini",
        },
      },
      display = {
        action_palette = {
          provider = "default",
        },
        chat = {
          -- show_references = true,
          -- show_header_separator = false,
          -- show_settings = false,
        },
        diff = {
          provider = "mini_diff",
        },
      },
      opts = {
        log_level = "DEBUG",
      },
    },
    init = function()
      vim.cmd([[cab cc CodeCompanion]])
    end,
    opts = {},
    config = function()
      require("legendary").keymaps({
        {
          itemgroup = "CodeCompanion",
          icon = "",
          description = "Use the power of AI...",
          keymaps = {
            {
              "<leader>l",
              "<cmd>CodeCompanionActions<CR>",
              description = "Open the action palette",
              mode = { "n", "v" },
            },
            -- {
            --   "<leader>a",
            --   "<cmd>CodeCompanionChat Toggle<CR>",
            --   description = "Toggle a chat buffer",
            --   mode = { "n", "v" },
            -- },
            -- {
            --   "ga",
            --   "<cmd>CodeCompanionChat Add<CR>",
            --   description = "Add selected text to a chat buffer",
            --   mode = { "n", "v" },
            -- },
          },
        },
      })
    end,
  },
}
