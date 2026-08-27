-- Rust IDE setup: LSP (rust-analyzer) + DAP (codelldb) via rustaceanvim
-- https://github.com/mrcjkb/rustaceanvim

local mason_registry = require "mason-registry"
local codelldb = mason_registry.get_package "codelldb"
local extension_path = codelldb:get_install_path() .. "/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

local function on_attach(_, bufnr)
  local map = vim.keymap.set
  local function opts(desc)
    return { buffer = bufnr, desc = "Rust " .. desc }
  end

  map("n", "K", function()
    vim.cmd.RustLsp { "hover", "actions" }
  end, opts "Hover Actions")

  map("n", "<leader>ca", function()
    vim.cmd.RustLsp "codeAction"
  end, opts "Code Action")

  map("n", "<leader>rr", function()
    vim.cmd.RustLsp "runnables"
  end, opts "Runnables")

  map("n", "<leader>rd", function()
    vim.cmd.RustLsp "debuggables"
  end, opts "Debuggables")

  map("n", "<leader>re", function()
    vim.cmd.RustLsp "expandMacro"
  end, opts "Expand Macro")

  map("n", "<leader>rp", function()
    vim.cmd.RustLsp "parentModule"
  end, opts "Parent Module")

  map("n", "<leader>rc", function()
    vim.cmd.RustLsp "openCargo"
  end, opts "Open Cargo.toml")
end

vim.g.rustaceanvim = {
  server = {
    on_attach = on_attach,
    default_settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          buildScripts = { enable = true },
        },
        checkOnSave = true,
        check = { command = "clippy" },
        procMacro = { enable = true },
        inlayHints = {
          bindingModeHints = { enable = false },
          closureReturnTypeHints = { enable = "with_block" },
          lifetimeElisionHints = { enable = "skip_trivial" },
        },
      },
    },
  },
  dap = {
    adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path),
  },
}
