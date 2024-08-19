local lsp = require('lsp-zero')

lsp.preset('recommended')
lsp.nvim_workspace()
lsp.setup()

require'lspconfig'.arduino_language_server.setup {
  cmd = {
    "arduino-language-server",
    "-cli-config", "/Users/ben/Library/Arduino15/arduino-cli.yaml",
    "-fqbn", "rp2040:rp2040:rpipico",
    "-cli", "arduino-cli",
    "-clangd", "clangd"
  }
}

vim.diagnostic.config({ virtual_text = true })
