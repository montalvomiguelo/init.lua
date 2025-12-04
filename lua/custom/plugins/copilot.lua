return {
  'github/copilot.vim',
  config = function()
    -- Disable Copilot for certain filetypes
    vim.g.copilot_filetypes = {
      rust = false,
      java = false,
      cpp = false,
      python = false,
      kotlin = false,
      c = false,
    }
  end,
}
