local function feedkey(key, mode)
  vim.fn.feedkeys(vim.keycode(key), mode or vim.api.nvim_get_mode().mode)
end

return {

  -- Plugin: mason lsp integration
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "clangd",
        "rust_analyzer"
      },
    },
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      "neovim/nvim-lspconfig",
    }
  },

  -- Plugin: Snippet engine
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    dependencies = {
      "rafamadriz/friendly-snippets",

    },
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    config = function()
      local ls = require("luasnip")
      local legendary = require("legendary")

      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets" })

      ls.filetype_extend("cpp", { "cppdoc" })
      ls.config.set_config({
        history = true,
        update_events = "TextChanged,TextChangedI",
      })

      legendary.keymaps({
        itemgroup = "snippets",
        icon = "",
        description = "LuaSnip navigation",
        keymaps = {
          {
            "<C-e>",
            function()
              if ls.choice_active() then
                ls.change_choice(1)
              end
            end,
            description = "Select choice node alternative",
            mode = { "i", "s" },
          },
          {
            "<C-j>",
            function()
              return ls.jumpable() and ls.expand_or_jump()
            end,
            description = "Jump to next placeholder",
            mode = { "i", "s" },
          },
          {
            "<C-k>",
            function()
              return ls.in_snippet() and ls.jumpable(-1) and ls.jump(-1)
            end,
            description = "Jump to previous placeholder",
            mode = { "i", "s" },
          },
        },
      })
    end,
  },
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
      { "L3MON4D3/LuaSnip", version = 'v2.*' },
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
        preset = 'none',
        -- ['<Up>'] = { 'select_prev', 'fallback' },
        -- ['<Down>'] = { 'select_next', 'fallback' },
        -- ['<Esc>'] = { 'hide', 'fallback' },
        ['<C-s>'] = { 'show', 'fallback' },
        ['<C-f>'] = { 'hide', 'fallback' },
        ['<C-n>'] = { 'select_and_accept', 'fallback' },
        -- ['<CR>'] = { 'accept', 'fallback' },
        ['<C-l>'] = { 'select_next', 'fallback' },
        ['<C-h>'] = { 'select_prev', 'fallback' },
        -- ['<Tab>'] = { 'snippet_forward', 'fallback' },
        -- ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      },

      snippets = { preset = 'luasnip' },
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
        default = function(ctx)
          local sources = { 'lsp', 'path', 'snippets', 'buffer' }
          if package.loaded["codecompanion"] then
            table.insert(sources, "codecompanion")
          end
          return sources
        end,
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
      "j-hui/fidget.nvim",
      { "custom/qfclose", dev = true },
    },
    ft = { 'lua', 'python', 'c', 'cpp', 'rust' },
    config = function(_, opts)
      vim.keymap.del({ "n", "x" }, "gra")
      vim.keymap.del("n", "gri")
      vim.keymap.del("n", "grn")
      vim.keymap.del("n", "grr")

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

      -- TODO: this entire section from here is a mess
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

      local function mappings(client, bufnr)
        if
            #vim.tbl_filter(function(keymap)
              return (keymap.desc or ""):lower() == "rename symbol"
            end, vim.api.nvim_buf_get_keymap(bufnr, "n")) > 0
        then
          return {}
        end

        legendary.keymaps({
          itemgroup = "LSP",
          icon = "",
          description = "LSP related functionality",
          keymaps = {
            {
              "gq",
              function()
                require("conform").format({ async = true, bufnr = bufnr, lsp_format = "fallback" })
              end,
              description = "Format",
              opts = { buffer = bufnr },
            },
            {
              "gr",
              function()
                vim.lsp.buf.references()
              end,
              description = "Find references",
              opts = { buffer = bufnr },
            },
            {
              "gl",
              function() vim.diagnostic.open_float(0, { border = 'single', source = 'always' }) end,
              description = "Show line diagnostics",
              opts = { buffer = bufnr },
            },
            {
              "K",
              vim.lsp.buf.hover,
              description = "Show hover information",
              opts = { buffer = bufnr },
            },

            {
              "gd",
              vim.lsp.buf.definition,
              description = "Go to definition",
              opts = { buffer = bufnr },
            },
            {
              "gi",
              vim.lsp.buf.implementation,
              description = "Go to implementation",
              opts = { buffer = bufnr },
            },
            {
              "gt",
              vim.lsp.buf.type_definition,
              description = "Go to type definition",
              opts = { buffer = bufnr },
            },
            {
              "<leader>p",
              t.lazy_required_fn("nvim-treesitter.textobjects.lsp_interop", "peek_definition_code", "@block.outer"),
              description = "Peek definition",
              opts = { buffer = bufnr },
            },
            {
              "ga",
              vim.lsp.buf.code_action,
              description = "Show code actions",
              opts = { buffer = bufnr },
            },
            {
              "gs",
              vim.lsp.buf.signature_help,
              description = "Show signature help",
              opts = { buffer = bufnr },
            },
            {
              "grn",
              vim.lsp.buf.rename,
              description = "Rename symbol",
              opts = { buffer = bufnr },
            },

            {
              "[",
              function()
                vim.diagnostic.jump({ count = -1, float = true })
              end,
              description = "Go to previous diagnostic item",
              opts = { buffer = bufnr },
            },
            {
              "]",
              function()
                vim.diagnostic.jump({ count = 1, float = true })
              end,
              description = "Go to next diagnostic item",
              opts = { buffer = bufnr },
            },
            {
              "gx",
              require("qfclose").close_latest,
              description = "Go to next diagnostic item",
            },
          },
        })
      end

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
          mappings(client, bufnr)
        end,
      })

      vim.diagnostic.config({
        severity_sort = true,
        underline = false,
        -- TODO: test what toggling these does
        update_in_insert = true,
        virtual_text = false,
        float = { border = 'single' },
        -- virtual_text = {
        --   prefix = "",
        --   spacing = 0,
        -- },
      })
    end,
  }

}
