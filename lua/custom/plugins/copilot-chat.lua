return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      auto_insert_mode = true,
      window = {
        width = 0.4,
      },
    },
    keys = {
      { '<c-s>', '<CR>', ft = 'copilot-chat', desc = 'Submit Prompt', remap = true },
      { '<leader>a', '', desc = '+ai', mode = { 'n', 'x' } },
      {
        '<leader>aa',
        function()
          return require('CopilotChat').toggle()
        end,
        desc = 'Toggle (CopilotChat)',
        mode = { 'n', 'x' },
      },
      {
        '<leader>ax',
        function()
          return require('CopilotChat').reset()
        end,
        desc = 'Clear (CopilotChat)',
        mode = { 'n', 'x' },
      },
      {
        '<leader>aq',
        function()
          vim.ui.input({
            prompt = 'Quick Chat: ',
          }, function(input)
            if input ~= '' then
              require('CopilotChat').ask(input)
            end
          end)
        end,
        desc = 'Quick Chat (CopilotChat)',
        mode = { 'n', 'x' },
      },
      {
        '<leader>ap',
        function()
          require('CopilotChat').select_prompt()
        end,
        desc = 'Prompt Actions (CopilotChat)',
        mode = { 'n', 'x' },
      },
    },
    config = function(_, opts)
      local chat = require 'CopilotChat'

      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = 'copilot-chat',
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup(opts)
    end,
    -- See Commands section for default commands if you want to lazy load on them
  },
}
