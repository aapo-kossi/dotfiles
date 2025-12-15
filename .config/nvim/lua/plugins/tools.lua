return {

  -- Plugin: undotree
  {
    'mbbill/undotree',
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle undo tree" }
    },
  },

  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
      -- VimTeX configuration goes here, e.g.
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_latexmk = {
        options = {
          '-xelatex',
          '-file-line-error',
          '-synctex=1',
          '-interaction=nonstopmode',
          '-f',
        },
      }
    end
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
    priority = 500,
    config = function()
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
        "<cmd>Trouble todo toggle<CR>",
        desc = "List all project todos using Trouble"
      },
      {
        "<leader>tn",
        function() require("todo-comments").jump_next() end,
        desc = "Jump to next todo comment"
      },
      {
        "<leader>tN",
        function() require("todo-comments").jump_prev() end,
        desc = "Jump to previous todo comment"
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
    -- enabled = false, -- PACS exam requirements
    dependencies = {
      {
        "echasnovski/mini.diff",
        config = function()
          local diff = require("mini.diff")
          diff.setup({
            -- Disabled by default
            source = diff.gen_source.none(),
          })
        end,
        "saghen/blink.cmp",
      },
      {
        "Davidyz/VectorCode",
        version = "*", -- optional, depending on whether you're on nightly or release
        dependencies = { "nvim-lua/plenary.nvim" },
        build = "pipx upgrade vectorcode",
        cmd = "VectorCode", -- if you're lazy-loading VectorCode
      }
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
        "<cmd>CodeCompanionActions<CR>",
        desc = "Open the action palette",
        mode = { "n", "v" },
      },
      {
        "<leader>c",
        "<cmd>CodeCompanionChat Toggle<CR>",
        desc = "Toggle the chat",
        mode = { "n" },
      },
    },
    opts = function()
      require("vectorcode")
      return {
        extensions = {
          vectorcode = {
            opts = { add_tool = true, add_slash_command = true, tool_opts = {} },
          },
        },
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
      }
    end,
    init = function()
      vim.cmd([[cab cc CodeCompanion]])
    end,
  },
}
