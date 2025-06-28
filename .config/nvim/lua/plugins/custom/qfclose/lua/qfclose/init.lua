-- lua/plugins/qfclose.lua

local M = {}
local qf_stack = {} -- This stack will hold window IDs of opened quickfix/location lists

-- Create a dedicated autocommand group for our plugin.
-- This helps in managing and clearing autocommands specific to this plugin.
local augroup = vim.api.nvim_create_augroup("QfCloseStack", { clear = true })

--- Sets up the autocommands for tracking quickfix/location list windows.
-- This function should be called once when the plugin is loaded.
function M.setup(_)
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = { "qf", "loclist" },
    callback = function(args)
      table.insert(qf_stack, args.buf)
    end,
  })

  -- Autocommand to remove window IDs from the stack when they are closed by any means (e.g., manually).
  -- This keeps the stack clean and prevents trying to close non-existent windows.
  vim.api.nvim_create_autocmd("WinClosed", {
    group = augroup,
    callback = function(args)
      local closed_win_id = args.buf
      -- Iterate backwards to safely remove elements while iterating
      for i = #qf_stack, 1, -1 do
        if qf_stack[i] == closed_win_id then
          table.remove(qf_stack, i)
          break
        end
      end
    end,
  })
end

--- Closes the most recently opened valid quickfix or location list window from the stack.
-- If the top of the stack refers to an invalid (already closed) window, it will pop
-- it and try the next one until a valid window is found or the stack is empty.
function M.close_latest()
  local closed_something = false
  -- Loop while there are items in the stack
  while #qf_stack > 0 do
    local win_id = table.remove(qf_stack) -- Pop the latest opened window ID from the stack

    if vim.api.nvim_buf_is_valid(win_id) then
      -- If the window ID is valid (the window still exists), close it.
      vim.api.nvim_buf_delete(win_id, { force = true }) -- 'true' forces the close
      closed_something = true
      break -- Successfully closed a window, exit the loop
    else
      -- The window was already closed (e.g., manually) and the WinClosed autocmd
      -- might not have processed it yet
    end
  end

  if not closed_something then
    -- If no quickfix/location list window was found or all tracked windows were invalid.
    vim.notify("No active quickfix or location list window found.")
  end
end

function M.get_stack()
  return qf_stack
end

--- Prints the current state of the internal stack to Neovim messages.
-- Includes validity check for each window ID.
-- @param message string (optional): A message to prepend to the stack output.
function M.print_stack(message)
  local msg_prefix = message and (message .. ": ") or "QfClose Stack: "
  if #qf_stack == 0 then
    vim.notify(msg_prefix .. "Empty", vim.log.levels.INFO, { title = "qf-close.nvim" })
  else
    local stack_output = { msg_prefix .. "[\n" }
    for i, win_id in ipairs(qf_stack) do
      table.insert(stack_output,
        string.format("  [%d]: %d (valid: %s),\n", i, win_id, tostring(vim.api.nvim_win_is_valid(win_id))))
    end
    table.insert(stack_output, "]")
    vim.notify(table.concat(stack_output), vim.log.levels.INFO, { title = "qf-close.nvim", timeout = 5000 })
  end
end

return M
