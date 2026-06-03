local function setup_lsp()
  -- 1. UI & Diagnostics
  -- require("lspconfig.ui.windows").default_options.border = "single"

  vim.keymap.del({ "n", "x" }, "gra")
  vim.keymap.del("n", "gri")
  vim.keymap.del("n", "grn")
  vim.keymap.del("n", "grr")

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then return end

      pcall(vim.keymap.del, "n", "K", { buffer = bufnr })

      -- 1. BUFFER-LOCAL MAPPINGS (Run once per file)
      if not vim.b[bufnr].lsp_set then
        local legendary = require("legendary")
        legendary.keymaps({
          itemgroup = "LSP",
          icon = "",
          description = "LSP related functionality",
          keymaps = {
            { "gr",  vim.lsp.buf.references,                                      description = "Find references", opts = { buffer = bufnr } },
            { "K",   vim.lsp.buf.hover,                                           description = "Show hover",      opts = { buffer = bufnr } },
            { "gq",  function() require("conform").format({ bufnr = bufnr }) end, description = "Format",          opts = { buffer = bufnr } },
            { "gd",  vim.lsp.buf.definition,                                      description = "Definition",      opts = { buffer = bufnr } },
            { "ga",  vim.lsp.buf.code_action,                                     description = "Code Action",     opts = { buffer = bufnr } },
            { "grn", vim.lsp.buf.rename,                                          description = "Rename",          opts = { buffer = bufnr } },
            {
              "K",
              function()
                vim.lsp.buf.hover({ border = "shadow" })
              end,
              description = "Show LSP hover information",
              mode = "n",
            },
          }
        })

        -- Mark this buffer as "configured"
        vim.b[bufnr].lsp_set = true
      end

      -- 2. CLIENT-SPECIFIC LOGIC (Run for specific servers)
      -- This handles the Ruff vs Pyright conflict specifically
      if client.name == 'ruff' then
        client.server_capabilities.hoverProvider = false
      end

      -- 3. CAPABILITY-SPECIFIC LOGIC (Run if the server supports it)
      -- We still want to check this per-client because one server might
      -- support highlighting while another doesn't.
      if client:supports_method("textDocument/documentHighlight") then
        local group = vim.api.nvim_create_augroup("LspHighlighting" .. bufnr, { clear = false })
        -- ... register your CursorHold autocmds here
      end
    end,
  })

  -- 4. Server Activation (The 0.12 Way)
  -- Instead of lspconfig[name].setup({}), use vim.lsp.enable()
  -- This looks up the default config from the built-in registry.

  -- local servers = {
  --   ruff = {
  --     settings = {
  --       -- Your specific ruff settings here...
  --     }
  --   },
  --   pyright = {},
  --   clangd = {},
  --   rust_analyzer = {},
  -- }
  local servers = {
    ltex_plus = {
      ltex = {
        language = { "en-UK" },
        enabled = { "tex", "latex", "markdown", "rst" },
      }
      -- TODO: fill
    },
    ruff = {
      init_options = {
        settings = {
          configuration = {
            lint = {
              unfixable = { "F401" },
              ["extend-select"] = { "TID251" },
              ["flake8-tidy-imports"] = {
                ["banned-api"] = {
                  ["typing.TypedDict"] = {
                    msg = "Use `typing_extensions.TypedDict` instead"
                  }
                }
              }
            },
            format = {
              ["quote-style"] = "single"
            }
          }
        }
      }
    }
  }

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true
  }
  vim.lsp.config('*', { capabilities = capabilities })

end

setup_lsp()
