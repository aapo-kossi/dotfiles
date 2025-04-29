return {

  commands = {
    {
      "FormatWrite",
      function()
        -- TODO: fix
        require("conform").format({ async = true })
        vim.lsp.buf.format({
          callback = function()
            vim.cmd('write')
          end
        })
      end
    },
  },

  autocmds =
  {
    {
      "BufWritePre",
      function()
        local save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
      end,
      opts = {
        pattern = "*"
      }
    },

    {
      "FileType",
      function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.expandtab = true
      end,
      opts = {
        pattern = "cpp",
      }
    },

    {
      "FileType",
      function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.expandtab = true
      end,
      opts = {
        pattern = "lua"
      }
    },
  },
}
