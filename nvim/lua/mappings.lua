require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "gl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Debugging (nvim-dap)
map("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "Dap Toggle Breakpoint" })

map("n", "<leader>dc", function()
  require("dap").continue()
end, { desc = "Dap Continue" })

map("n", "<leader>di", function()
  require("dap").step_into()
end, { desc = "Dap Step Into" })

map("n", "<leader>do", function()
  require("dap").step_over()
end, { desc = "Dap Step Over" })

map("n", "<leader>dO", function()
  require("dap").step_out()
end, { desc = "Dap Step Out" })

map("n", "<leader>dt", function()
  require("dap").terminate()
end, { desc = "Dap Terminate" })

map("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "Dap UI Toggle" })
