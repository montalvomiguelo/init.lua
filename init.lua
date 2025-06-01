-- Set <,> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!

-- Whitespace
vim.opt.wrap = false
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.list = true
vim.opt.backspace = 'indent,eol,start'

-- Highlight problematic whitespace
vim.opt.listchars = {
  tab = '  ', -- a tab should display as "  "
  trail = '.', -- show trailing spaces as dots
  extends = '>', -- The character to show in the last column when wrap is off and the line continues beyond the right of the screen
  precedes = '<', -- The character to show in the last column when wrap is off and the line continues beyond the left of the screen
}

-- Highlight current line
vim.opt.cursorline = true

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Search
vim.opt.grepprg = 'rg --vimgrep'

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- No gui cursor
vim.opt.guicursor = ''

-- NOTE: You should make sure your terminal supports this
vim.opt.termguicolors = true

-- [[ Basic Keymaps ]]

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Clear search result highlight
vim.keymap.set('n', '<C-l>', '<Cmd>nohlsearch<CR><C-l>', { silent = true, noremap = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1 }
end, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1 }
end, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Highlight on yank ]]
-- See `:help vim.hl.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

--[[ VSCode plugins ]]
local enabled = {
  'lazy.nvim',
  'vim-surround',
  'vim-unimpaired',
}

-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  {
    'tpope/vim-fugitive',
    config = function()
      -- Git keymaps
      vim.keymap.set('n', '<leader>gb', '<Cmd>Git blame<CR>', { silent = true })
      vim.keymap.set('n', '<leader>gs', '<Cmd>Git<CR>', { silent = true })
      vim.keymap.set('n', '<leader>gd', '<Cmd>Gdiff<CR>', { silent = true })
      vim.keymap.set('n', '<leader>gl', '<Cmd>Gclog<CR>', { silent = true })
      vim.keymap.set('n', '<leader>gc', '<Cmd>Git commit<CR>', { silent = true })
      vim.keymap.set('n', '<leader>gp', '<Cmd>Git push<CR>', { silent = true })
    end,
  },

  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      -- [[ Configure LSP ]]
      --  This function gets run when an LSP connects to a particular buffer.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('LspAttachConfig', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself
          -- many times.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local nmap = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
          nmap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
          nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
          nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

          -- See `:help K` for why this keymap
          nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
          nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

          -- Lesser used LSP functionality
          nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        end,
      })

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. They will be passed to
      --  the `settings` field of the server config. You must look up that documentation yourself.
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ts_ls = {},

        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      }

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 3000,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list-
        javascript = { 'prettier' },
        liquid = { 'prettier', stop_after_first = true },
      },
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- Adds a number of user-friendly snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- [[ Configure nvim-cmp ]]
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-y>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          },
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        },
      }
    end,
  },

  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  {
    -- Theme
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false },
          keywords = { italic = false },
        },
      }

      vim.cmd.colorscheme 'tokyonight-moon'
    end,
    version = '3.0.1',
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy file, buffer, mru, tag, etc finder
  {
    'ctrlpvim/ctrlp.vim',
    init = function()
      vim.g.ctrlp_user_command = 'rg %s --files'
      vim.g.ctrlp_use_caching = 0
    end,
  },

  -- Use :Ack command for real-time grep
  {
    'montalvomiguelo/ack.vim',
    keys = {
      { '<leader>F', ':Ack!<Space>', mode = 'n', desc = '[S]earch by [G]rep' },
    },
    init = function()
      vim.g.ackprg = 'rg --vimgrep'
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim' },

      -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
      auto_install = false,

      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function()
      -- [[ Configure Treesitter ]]
      -- See `:help nvim-treesitter`
    end,
  },

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  { import = 'custom.plugins' },
}, {
  -- If you are using a Nerd Font: set icons to an empty table which will use the
  -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
  ui = {
    icons = {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },

  -- VSCode specific config
  checker = { enabled = not vim.g.vscode, notify = not vim.g.vscode },
  change_detection = { enabled = not vim.g.vscode, notify = not vim.g.vscode },
  defaults = {
    cond = function(plugin)
      if vim.g.vscode then
        return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
      end
      return true
    end,
  },
})

-- [[ VSCode specifig keymaps ]]
if vim.g.vscode then
  -- VSCode-specific keymaps for search and navigation
  vim.keymap.set('n', '<leader><space>', '<cmd>Find<cr>')
  vim.keymap.set('n', '<leader>F', [[<cmd>lua require('vscode').action('workbench.action.findInFiles')<cr>]])
  -- vim.keymap.set('n', '<leader>ss', [[<cmd>lua require('vscode').action('workbench.action.gotoSymbol')<cr>]])

  -- Keep undo/redo lists in sync with VsCode
  vim.keymap.set('n', 'u', "<Cmd>call VSCodeNotify('undo')<CR>")
  vim.keymap.set('n', '<C-r>', "<Cmd>call VSCodeNotify('redo')<CR>")

  -- Navigate VSCode tabs like lazyvim buffers
  -- vim.keymap.set('n', '<S-h>', "<Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>")
  -- vim.keymap.set('n', '<S-l>', "<Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>")
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
