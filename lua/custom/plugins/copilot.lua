return {
  'github/copilot.vim',
  config = function()
    -- Disable Copilot for certain filetypes
    vim.g.copilot_filetypes = {
      rust = false,
      java = false,
      cppp = false,
      python = false,
    }
  end,
}
