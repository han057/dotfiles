require "nvchad.autocmds"

-- Autosave: silently write modifiable, named buffers when leaving insert
-- mode, after changes settle, or when focus leaves the editor.
local autosave_grp = vim.api.nvim_create_augroup("AutoSave", { clear = true })

local function autosave()
  local buf = vim.api.nvim_get_current_buf()
  if
    vim.bo[buf].modifiable
    and vim.bo[buf].buftype == ""
    and vim.api.nvim_buf_get_name(buf) ~= ""
    and vim.bo[buf].modified
  then
    vim.api.nvim_buf_call(buf, function()
      vim.cmd "silent! write"
    end)
  end
end

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost" }, {
  group = autosave_grp,
  pattern = "*",
  callback = autosave,
})
