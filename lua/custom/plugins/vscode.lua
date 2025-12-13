if not vim.g.vscode then
  return {}
end

-- Add some vscode specific keymaps
vim.api.nvim_create_autocmd('User', {
  pattern = 'VSCodeOverrides',
  group = vim.api.nvim_create_augroup('VSCodeOverridesKeymaps', { clear = true }),
  callback = function()
    -- VSCode-specific keymaps for search and navigation
    vim.keymap.set('n', '<leader><space>', '<cmd>Find<cr>')
    vim.keymap.set('n', '<leader>F', [[<cmd>lua require('vscode').action('workbench.action.findInFiles')<cr>]])
    vim.keymap.set('n', '<leader>rn', "<Cmd>call VSCodeNotify('editor.action.rename')<CR>")
    vim.keymap.set('n', '<leader>ca', "<Cmd>call VSCodeNotify('editor.action.quickFix')<CR>")
    vim.keymap.set('n', 'gr', "<Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>")
    vim.keymap.set('n', 'gI', "<Cmd>call VSCodeNotify('editor.action.goToImplementation')<CR>")
    vim.keymap.set('n', '<leader>D', "<Cmd>call VSCodeNotify('editor.action.goToTypeDefinition')<CR>")
    vim.keymap.set('n', 'gD', "<Cmd>call VSCodeNotify('editor.action.goToDeclaration')<CR>")

    -- Diagnostic keymaps
    vim.keymap.set('n', '[d', "<Cmd>call VSCodeNotify('editor.action.marker.prev')<CR>")
    vim.keymap.set('n', ']d', "<Cmd>call VSCodeNotify('editor.action.marker.next')<CR>")
    vim.keymap.set('n', '<leader>e', "<Cmd>call VSCodeNotify('editor.action.showHover')<CR>")

    -- Navigate VSCode tabs like lazyvim buffers
    vim.keymap.set('n', '<S-h>', "<Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>")
    vim.keymap.set('n', '<S-l>', "<Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>")
  end,
})

-- Add some vscode specific plugin overrides
return {
  -- {
  --   'nvim-treesitter/nvim-treesitter',
  --   opts = { highlight = { enable = false } },
  -- },
}
