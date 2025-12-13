if not vim.g.vscode then
  return {}
end

local vscode = require 'vscode'

-- Add some vscode specific keymaps
vim.api.nvim_create_autocmd('User', {
  pattern = 'VSCodeOverrides',
  group = vim.api.nvim_create_augroup('VSCodeOverridesKeymaps', { clear = true }),
  callback = function()
    -- VSCode-specific keymaps for search and navigation
    vim.keymap.set('n', '<leader><space>', '<cmd>Find<cr>')
    vim.keymap.set('n', '<leader>F', function()
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

    -- Navigate VSCode tabs like lazyvim buffers
    vim.keymap.set('n', '<S-h>', function()
      vscode.call 'workbench.action.previousEditor'
    end)
    vim.keymap.set('n', '<S-l>', function()
      vscode.call 'workbench.action.nextEditor'
    end)
  end,
})

-- Add some vscode specific plugin overrides
return {
  -- {
  --   'nvim-treesitter/nvim-treesitter',
  --   opts = { highlight = { enable = false } },
  -- },
}
