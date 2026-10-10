if not vim.g.vscode then
  return {}
end

local Config = require 'lazy.core.config'
local vscode = require 'vscode'
Config.options.change_detection.enabled = false

local enabled = {
  'lazy.nvim',
  'vim-surround',
  'vim-unimpaired',
  -- 'vim-trailing-whitespace'
}
Config.options.defaults.cond = function(plugin)
  return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
end

-- VSCode-specific keymaps for search and navigation
vim.keymap.set('n', '<leader><space>', '<cmd>Find<cr>')
vim.keymap.set('n', '<leader>f', function()
  vscode.call 'workbench.action.findInFiles'
end)
vim.keymap.set('n', '<leader>rn', function()
  vscode.call 'editor.action.rename'
end)
vim.keymap.set('n', '<leader>ca', function()
  vscode.call 'editor.action.quickFix'
end)
vim.keymap.set('n', 'gr', function()
  vscode.call 'editor.action.referenceSearch.trigger'
end)
vim.keymap.set('n', 'gI', function()
  vscode.call 'editor.action.goToImplementation'
end)
vim.keymap.set('n', '<leader>D', function()
  vscode.call 'editor.action.goToTypeDefinition'
end)
vim.keymap.set('n', 'gD', function()
  vscode.call 'editor.action.goToDeclaration'
end)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vscode.call 'editor.action.marker.prev'
end)
vim.keymap.set('n', ']d', function()
  vscode.call 'editor.action.marker.next'
end)
vim.keymap.set('n', '<leader>e', function()
  vscode.call 'editor.action.showHover'
end)

-- Navigate VSCode editors like buffers
vim.keymap.set('n', '<S-h>', function()
  vscode.call 'workbench.action.previousEditor'
end)
vim.keymap.set('n', '<S-l>', function()
  vscode.call 'workbench.action.nextEditor'
end)

return {}
