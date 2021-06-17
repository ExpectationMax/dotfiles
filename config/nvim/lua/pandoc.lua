local M = {}

function M.getCompletionItems(prefix)
  -- define your total completion items
  local items = vim.api.nvim_call_function('pandoc#completion#Complete',{0, prefix})
  return items
end

M.complete_item = {
  item = M.getCompletionItems,
  trigger_character = {'@'}
}

return M
