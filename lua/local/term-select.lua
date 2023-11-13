local terminal = require("toggleterm.terminal")
local M = {}
local win_id = -1

local function show_term(term)
  if term then
      if term:is_open() then
        term:focus()
      else
        term:open()
      end
    end
end

function M.show()
  local all_term = terminal.get_all(true)
  vim.ui.select(all_term, {
    prompt = "Select a terminal session",
    format_item = function(term)
      return term:_display_name() .. " - " .. term.dir
    end,
  }, show_term)
end

function M.new()
  local id = #terminal.get_all(true) + 1
  vim.cmd(id .. "ToggleTerm")
end

function M.next()
  local all_term = terminal.get_all(true)
  if not #all_term then
    return
  end
  local focus = terminal.get_focused_id()
  local id = focus + 1
  if id > #focus then
    id = 1
  end
  local term = terminal.get(id, true)
  show_term(term)
end

function M.prev()
  local all_term = terminal.get_all(true)
  if not #all_term then
    return
  end
  local focus = terminal.get_focused_id()
  local id = focus - 1
  if id < 1 then
    id = #all_term
  end
  local term = terminal.get(id, true)
  show_term(term)
end

return M
