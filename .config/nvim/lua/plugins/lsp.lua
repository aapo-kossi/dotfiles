return {

  -- Plugin: Mason (ls installation)
  { 'williamboman/mason.nvim' },

  -- Plugin: mason lsp integration
  { 'williamboman/mason-lspconfig.nvim' },

  -- completions
  {
    'saghen/blink.cmp',

    -- use a release tag to download pre-built binaries
    version = '*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',
    dependencies = {
      "rafamadriz/friendly-snippets",
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = 'default',
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<CR>'] = { 'select_and_accept', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
      },

      signature = { enabled = true },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = {
        documentation = { auto_show = false },
        accept = { auto_brackets = { enabled = true } },
        list = {
          selection = {
            preselect = false,
            auto_insert = false
          },
        },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'codecompanion' },
      },
      cmdline = { sources = { "cmdline" } },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },

  -- Plugin: folds
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "Open all folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "Close all folds",
      },
    },
  },

  -- Plugin: Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { "stylua" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        python = { "isort", "black" },
      },
      -- Set default options
      default_format_opts = {
        lsp_format = "fallback",
      },
      -- Set up format-on-save
      -- format_on_save = { timeout_ms = 500 },
      -- Customize formatters
      -- formatters = {
      --   shfmt = {
      --     prepend_args = { "-i", "2" },
      --   },
      -- },
    },
  },

  -- Plugin: code diagnostics
  {
    'folke/trouble.nvim',
    opts = {},
    cmd = "Trouble",
    lazy = true,
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
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "j-hui/fidget.nvim"
    },
    ft = { 'lua', 'python', 'c', 'cpp' },
    config = function(_, opts)
      -- TODO: test what toggling this does
      require("lspconfig.ui.windows").default_options.border = "single"

      require("ufo").setup()
      local blink = require("blink.cmp")
      local capabilities =
          vim.tbl_deep_extend("force", blink.get_lsp_capabilities(), opts.capabilities or {}, {
            -- TODO: test what toggling this does
            -- textDocument = {
            --   foldingRange = {
            --     dynamicRegistration = false,
            --     lineFoldingOnly = true,
            --   },
            -- },
          })

      local lspconfig_defaults = require("lspconfig").util.default_config
      lspconfig_defaults.capabilities = vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, capabilities)

      -- Legendary.nvim
      local legendary = require("legendary")
      local t = require("legendary.toolbox")

      local function autocmds(client, bufnr)
        if not client:supports_method("textDocument/documentHighlight") then
          return
        end
        legendary.autocmds({
          {
            name = "LspOnAttachAutocmds",
            clear = false,
            {
              { "CursorHold", "CursorHoldI" },
              ":silent! lua vim.lsp.buf.document_highlight()",
              opts = { buffer = bufnr },
            },
            {
              "CursorMoved",
              ":silent! lua vim.lsp.buf.clear_references()",
              opts = { buffer = bufnr },
            },
          },
        })
      end
      local function commands(client, bufnr)
        -- Only need to set these once!
        if vim.g.lsp_commands then
          return {}
        end

        legendary.commands({
          {
            ":LspRestart",
            description = "Restart any attached clients",
          },
          {
            ":LspStart",
            description = "Start the client manually",
          },
          {
            ":LspInfo",
            description = "Show attached clients",
          },
          {
            "LspInstallAll",
            function()
              for _, name in pairs(om.lsp.servers) do
                vim.cmd("LspInstall " .. name)
              end
            end,
            description = "Install all servers",
          },
          {
            "LspUninstallAll",
            description = "Uninstall all servers",
          },
          {
            "LspLog",
            function()
              vim.cmd("edit " .. vim.lsp.get_log_path())
            end,
            description = "Show logs",
          },
        })

        vim.g.lsp_commands = true
      end
      -- local function mappings(client, bufnr)
      --   if
      --     #vim.tbl_filter(function(keymap)
      --       return (keymap.desc or ""):lower() == "rename symbol"
      --     end, vim.api.nvim_buf_get_keymap(bufnr, "n")) > 0
      --   then
      --     return {}
      --   end
      --
      --   legendary.keymaps({
      --     itemgroup = "LSP",
      --     icon = "",
      --     description = "LSP related functionality",
      --     keymaps = {
      --       {
      --         "gf",
      --         function()
      --           require("snacks").picker.diagnostics_buffer()
      --         end,
      --         description = "Find diagnostics",
      --         opts = { noremap = true, buffer = bufnr },
      --       },
      --       {
      --         "gq",
      --         function()
      --           require("conform").format({ async = true, bufnr = bufnr, lsp_format = "fallback" })
      --         end,
      --         description = "Format",
      --         opts = { buffer = bufnr },
      --       },
      --       {
      --         "gr",
      --         function()
      --           require("snacks").picker.lsp_references()
      --         end,
      --         description = "Find references",
      --         opts = { buffer = bufnr },
      --       },
      --       {
      --         "gl",
      --         "<cmd>lua vim.diagnostic.open_float(0, { border = 'single', source = 'always' })<CR>",
      --         description = "Show line diagnostics",
      --         opts = { buffer = bufnr },
      --       },
      --       {
      --         "K",
      --         "<cmd>lua vim.lsp.buf.hover<CR>",
      --         description = "Show hover information",
      --         opts = { buffer = bufnr },
      --       },
      --
      --       {
      --         "gd",
      --         function()
      --           require("snacks").picker.lsp_definitions()
      --         end,
      --         description = "Go to definition",
      --         opts = { buffer = bufnr },
      --       },
      --       {
      --         "gi",
      --         "<cmd>lua vim.lsp.buf.implementation()<CR>",
      --         description = "Go to implementation",
      --         opts = { buffer = bufnr },
      --       },
      --       {
      --         "gt",
      --         "<cmd>lua vim.lsp.buf.type_definition()<CR>",
      --         description = "Go to type definition",
      --         opts = { buffer = bufnr },
      --       },
      --       {
      --         "<LocalLeader>p",
      --         t.lazy_required_fn("nvim-treesitter.textobjects.lsp_interop", "peek_definition_code", "@block.outer"),
      --         description = "Peek definition",
      --         opts = { buffer = bufnr },
      --       },
      --       {
      --         "ga",
      --         "<cmd>lua vim.lsp.buf.code_action()<CR>",
      --         description = "Show code actions",
      --         opts = { buffer = bufnr },
      --       },
      --       {
      --         "gs",
      --         "<cmd>lua vim.lsp.buf.signature_help()<CR>",
      --         description = "Show signature help",
      --         opts = { buffer = bufnr },
      --       },
      --       {
      --         "<LocalLeader>rn",
      --         "<cmd>lua vim.lsp.buf.rename()<CR>",
      --         description = "Rename symbol",
      --         opts = { buffer = bufnr },
      --       },
      --
      --       {
      --         "[",
      --         "<cmd>lua vim.diagnostic.jump({count = -1, float = true})<CR>",
      --         description = "Go to previous diagnostic item",
      --         opts = { buffer = bufnr },
      --       },
      --       {
      --         "]",
      --         "<cmd>lua vim.diagnostic.jump({count = 1, float = true})<CR>",
      --         description = "Go to next diagnostic item",
      --         opts = { buffer = bufnr },
      --       },
      --     },
      --   })
      -- end

      -- LspAttach is where you enable features that only work
      -- if there is a language server active in the file
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
          local id = vim.tbl_get(event, "data", "client_id")
          local client = id and vim.lsp.get_client_by_id(id)
          if client == nil then
            return
          end

          local bufnr = event.buf

          autocmds(client, bufnr)
          commands(client, bufnr)
          -- mappings(client, bufnr)
        end,
      })

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "clangd"
        },
        handlers = {
          -- this first function is the "default handler"
          -- it applies to every language server without a "custom handler"
          function(ls)
            require("lspconfig")[ls].setup({
              capabilities = capabilities,
            })
          end,
        },
      })

      vim.diagnostic.config({
        severity_sort = true,
        underline = false,
        -- TODO: test what toggling these does
        update_in_insert = true,
        virtual_text = false,
        -- virtual_text = {
        --   prefix = "",
        --   spacing = 0,
        -- },
      })
    end,
  }

}
