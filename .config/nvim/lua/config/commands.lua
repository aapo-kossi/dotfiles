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
    {
      "CheckSentences",
      function()
        local limit_input = vim.fn.input("Highlight sentences longer than: ", "20")
        local limit = tonumber(limit_input) or 20
        local ns = vim.api.nvim_create_namespace("sentence_highlighter")

        -- Clear previous highlights
        vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local content = table.concat(lines, "\n")
        local offset = 1

        while true do
          -- Matches any sequence of chars ending in . ! or ?
          -- [^.!?] includes newlines, so it handles source line breaks
          local s_start, s_end = content:find("[^.!?]+[.!?]", offset)
          if not s_start then break end

          local sentence = content:sub(s_start, s_end)
          local _, word_count = sentence:gsub("%S+", "")

          if word_count > limit then
            -- Convert byte offsets to 0-indexed line numbers for the API
            local function get_pos(pos)
              local l = vim.fn.byte2line(pos)
              local l_start = vim.fn.line2byte(l)
              return l - 1, pos - l_start
            end

            local start_line, start_col = get_pos(s_start)
            local end_line, end_col = get_pos(s_end)

            if start_line == end_line then
              vim.api.nvim_buf_add_highlight(0, ns, "ErrorMsg", start_line, start_col, end_col + 1)
            else
              -- First line: from start_col to end
              vim.api.nvim_buf_add_highlight(0, ns, "ErrorMsg", start_line, start_col, -1)
              -- Middle lines: full length
              for i = start_line + 1, end_line - 1 do
                vim.api.nvim_buf_add_highlight(0, ns, "ErrorMsg", i, 0, -1)
              end
              -- Last line: from 0 to end_col
              vim.api.nvim_buf_add_highlight(0, ns, "ErrorMsg", end_line, 0, end_col + 1)
            end
          end
          offset = s_end + 1
        end
        print("\nHighlighted sentences > " .. limit .. " words.")
      end
    },
    {
      "ClearSentences",
      function()
        local ns = vim.api.nvim_create_namespace("sentence_highlighter")
        vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
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
