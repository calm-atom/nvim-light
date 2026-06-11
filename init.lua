-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --

-- Show line numbers
vim.o.number = true

-- Show relative line numbers
vim.opt.relativenumber = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Enable 24-bit colors
-- Required when working via SSH
vim.o.termguicolors = true

-- Clear search highlights after submit
vim.o.hlsearch = false

-- Tab width
vim.o.tabstop = 2

-- Indent width
vim.o.shiftwidth = 2

-- Use spaces instead of tabs
vim.o.expandtab = true

-- Don't show mode
vim.o.showmode = false

-- Minimum number of screen lines to keep above and below the cursor
vim.o.scrolloff = 8

-- Faster completion
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Reserve space in gutter for signs
vim.o.signcolumn = 'yes'

-- Use rounded borders for windows
vim.o.winborder = 'rounded'

-- Open new split panes to right and below
vim.o.splitright = true
vim.o.splitbelow = true

-- Save undo history
vim.o.undofile = true

-- Raise dialog to save current file(s) if operation would fail due to unsaved changes
vim.o.confirm = true

-- Space as leader key
vim.g.mapleader = vim.keycode('<Space>')

-- Use a light background
vim.o.background = 'light'

-- Small QoL
vim.o.cursorline = true
vim.o.inccommand = 'split'
vim.o.completeopt = 'menu,menuone,noselect'
vim.o.pumheight = 10
vim.o.jumpoptions = 'stack'

-- Whitespace visibility
vim.o.list = true
vim.opt.listchars = {
  tab = '» ',
  trail = '·',
  nbsp = '␣',
}

-- Fix clipboard over SSH
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}

-- Basic clipboard interaction
-- Default yank goes to register
vim.keymap.set({ 'n', 'x' }, 'gy', '"+y', { desc = 'Copy to clipboard' })
vim.keymap.set({ 'n', 'x' }, 'gp', '"+p', { desc = 'Paste clipboard content' })

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

vim.pack.add({
  {
    src = 'https://github.com/nvim-mini/mini.nvim',
    version = 'main',
  },

  {
    src = 'https://github.com/folke/snacks.nvim',
  },

  {
    src = 'https://github.com/neovim/nvim-lspconfig',
  },

  {
    src = 'https://github.com/stevearc/conform.nvim',
  },

  {
    src = 'https://github.com/rktjmp/lush.nvim',
  },

  {
    src = 'https://github.com/zenbones-theme/zenbones.nvim',
  },

  {
    src = 'https://github.com/nvim-lua/plenary.nvim',
  },

  {
    src = 'https://github.com/sindrets/diffview.nvim',
  },

  {
    src = 'https://github.com/NeogitOrg/neogit',
  },

  {
    src = 'https://github.com/folke/flash.nvim',
  },

  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'master',
  },

  {
    src = 'https://github.com/rafamadriz/friendly-snippets',
  },

  {
    src = 'https://github.com/saghen/blink.cmp',
    version = 'v1.10.1',
  },

  {
    src = 'https://github.com/b0o/SchemaStore.nvim',
  },

  {
    src = 'https://github.com/j-hui/fidget.nvim',
  },

  {
    src = 'https://github.com/folke/trouble.nvim',
  },
})

-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

-- vim.cmd.colorscheme('rosebones')
vim.cmd.colorscheme('zenwritten')
-- vim.cmd.colorscheme('quiet')

-- Snacks.nvim

require('snacks').setup({
  bigfile = { enabled = true },
  
  dashboard = {
    enabled = true,
    preset = {
          header = [[
                                                                   
      ████ ██████           █████      ██                 btw
     ███████████             █████                            
     █████████ ███████████████████ ███   ███████████  
    █████████  ███    █████████████ █████ ██████████████  
   █████████ ██████████ █████████ █████ █████ ████ █████  
 ███████████ ███    ███ █████████ █████ █████ ████ █████ 
██████  █████████████████████ ████ █████ █████ ████ ██████
]],
      keys = {
        {
          icon = ' ',
          key = 'f',
          desc = 'Find File',
          action = function()
            Snacks.picker.files()
          end,
        },
        {
          icon = ' ',
          key = 'r',
          desc = 'Recent Files',
          action = function()
            Snacks.picker.recent()
          end,
        },
        {
          icon = ' ',
          key = 'g',
          desc = 'Grep',
          action = function()
            Snacks.picker.grep()
          end,
        },
        {
          icon = ' ',
          key = 'e',
          desc = 'Explorer',
          action = function()
            Snacks.explorer()
          end,
        },
        {
          icon = ' ',
          key = 'c',
          desc = 'Config',
          action = function()
            Snacks.picker.files({ cwd = vim.fn.stdpath('config') })
          end,
        },
        {
          icon = ' ',
          key = 'q',
          desc = 'Quit',
          action = ':qa',
        },
      },
    },
    sections = {
      { section = 'header' },
      { section = 'keys', gap = 1, padding = 1 },
      {
        icon = ' ',
        title = 'Recent Files',
        section = 'recent_files',
        indent = 2,
        padding = 1,
      },
    },
  },

  explorer = {
    enabled = true,
    replace_netrw = true,
  },

  indent = { enabled = true },
  input = { enabled = true },

  notifier = {
    enabled = true,
    timeout = 3000,
  },

  
picker = {
  enabled = true,
  sources = {
    explorer = {
      actions = {
        confirm_or_close = function(picker, item)
          if not item then
            return
          end

          -- Directories should expand/collapse but keep explorer open
          if item.dir then
            picker:action('confirm')
            return
          end

          -- Files should open, then close explorer
          picker:action('confirm')

          vim.schedule(function()
            pcall(function()
              picker:close()
            end)
          end)
        end,
      },

      win = {
        list = {
          keys = {
            ['<CR>'] = 'confirm_or_close',
            ['l'] = 'confirm_or_close',
          },
        },
      },
    },
  },
},

  -- picker = { enabled = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  terminal = { enabled = true },
  lazygit = { enabled = true },
})

-- Mini modules kept because Snacks has no true equivalent
require('mini.icons').setup({})
require('mini.comment').setup({})
require('mini.pairs').setup({})
require('mini.ai').setup({})
require('mini.surround').setup({})
require('mini.move').setup({})
require('mini.splitjoin').setup({})
require('mini.trailspace').setup({})
require('mini.sessions').setup({})
require('mini.bracketed').setup({})
require('mini.statusline').setup({})

local hipatterns = require('mini.hipatterns')
hipatterns.setup({
  highlighters = {
    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
    todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
    note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})


-- Fidget: LSP progress/notifications
require('fidget').setup({
  notification = {
    window = { winblend = 0 },
  },
})

-- Trouble
require('trouble').setup({})

vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', {
  desc = 'Diagnostics list',
})

vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', {
  desc = 'Buffer diagnostics list',
})

vim.keymap.set('n', '<leader>cs', '<cmd>Trouble symbols toggle<cr>', {
  desc = 'Symbols',
})

vim.keymap.set('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', {
  desc = 'LSP Definitions / references / ...',
})

vim.keymap.set('n', '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', {
  desc = 'Quickfix list',
})

-- Flash
require('flash').setup({
  modes = {
    char = { jump_labels = true },
  },
})

vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
  require('flash').jump()
end, { desc = 'Flash jump' })

vim.keymap.set({ 'n', 'x', 'o' }, 'S', function()
  require('flash').treesitter()
end, { desc = 'Flash treesitter selection' })

-- ========================================================================== --
-- ==                         SNACKS KEYMAPS                               == --
-- ========================================================================== --

-- File explorer
vim.keymap.set('n', '<leader>e', function()
  Snacks.explorer()
end, { desc = 'File explorer' })

vim.keymap.set('n', '<leader>E', function()
  Snacks.explorer.reveal()
end, { desc = 'Reveal file in explorer' })

-- Picker
vim.keymap.set('n', '<leader>?', function()
  Snacks.picker.recent()
end, { desc = 'Search file history' })

vim.keymap.set('n', '<leader><space>', function()
  Snacks.picker.buffers()
end, { desc = 'Search open files' })

vim.keymap.set('n', '<leader>ff', function()
  Snacks.picker.files()
end, { desc = 'Search all files' })

vim.keymap.set('n', '<leader>fg', function()
  Snacks.picker.grep()
end, { desc = 'Search in project' })

vim.keymap.set('n', '<leader>fd', function()
  Snacks.picker.diagnostics()
end, { desc = 'Search diagnostics' })

vim.keymap.set('n', '<leader>fD', function()
  Snacks.picker.diagnostics_buffer()
end, { desc = 'Search buffer diagnostics' })

vim.keymap.set('n', '<leader>fs', function()
  Snacks.picker.lines()
end, { desc = 'Buffer local search' })

vim.keymap.set('n', '<leader>fr', function()
  Snacks.picker.resume()
end, { desc = 'Resume picker' })

vim.keymap.set('n', '<leader>fh', function()
  Snacks.picker.help()
end, { desc = 'Search help' })

vim.keymap.set('n', '<leader>fk', function()
  Snacks.picker.keymaps()
end, { desc = 'Search keymaps' })

vim.keymap.set('n', '<leader>fc', function()
  Snacks.picker.commands()
end, { desc = 'Search commands' })

vim.keymap.set('n', '<leader>fu', function()
  Snacks.picker.undo()
end, { desc = 'Undo history' })

-- Git pickers
vim.keymap.set('n', '<leader>gc', function()
  Snacks.picker.git_log()
end, { desc = 'Search Git commits' })

vim.keymap.set('n', '<leader>gb', function()
  Snacks.picker.git_branches()
end, { desc = 'Search Git branches' })

vim.keymap.set('n', '<leader>gs', function()
  Snacks.picker.git_status()
end, { desc = 'Search modified files' })

vim.keymap.set('n', '<leader>gd', function()
  Snacks.picker.git_diff()
end, { desc = 'Git diff hunks' })

vim.keymap.set('n', '<leader>gf', function()
  Snacks.picker.git_log_file()
end, { desc = 'Git log current file' })

-- Buffer navigation
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })
vim.keymap.set('n', '[b', '<cmd>bprev<cr>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>bb', '<c-^>', { desc = 'Toggle last buffer' })

-- Buffer management
vim.keymap.set('n', '<leader>bd', function()
  Snacks.bufdelete()
end, { desc = 'Delete buffer' })

-- Notifications
vim.keymap.set('n', '<leader>nh', function()
  Snacks.notifier.show_history()
end, { desc = 'Notification history' })

vim.keymap.set('n', '<leader>nd', function()
  Snacks.notifier.hide()
end, { desc = 'Dismiss notifications' })

-- Terminal / Lazygit / Zen / Scratch
vim.keymap.set('n', '<leader>gg', function()
  Snacks.lazygit()
end, { desc = 'Lazygit' })

vim.keymap.set('n', '<leader>z', function()
  Snacks.zen()
end, { desc = 'Zen mode' })

vim.keymap.set('n', '<leader>Z', function()
  Snacks.zen.zoom()
end, { desc = 'Zoom window' })

vim.keymap.set({ 'n', 't' }, '<C-/>', function()
  Snacks.terminal()
end, { desc = 'Toggle terminal' })

vim.keymap.set({ 'n', 't' }, '<C-_>', function()
  Snacks.terminal()
end, { desc = 'Toggle terminal' })

vim.keymap.set('n', '<leader>.', function()
  Snacks.scratch()
end, { desc = 'Toggle scratch buffer' })

vim.keymap.set('n', '<leader>S', function()
  Snacks.scratch.select()
end, { desc = 'Select scratch buffer' })

-- LSP reference jumps from Snacks.words
vim.keymap.set({ 'n', 't' }, ']]', function()
  Snacks.words.jump(vim.v.count1)
end, { desc = 'Next reference' })

vim.keymap.set({ 'n', 't' }, '[[', function()
  Snacks.words.jump(-vim.v.count1)
end, { desc = 'Previous reference' })

-- Git browse
vim.keymap.set({ 'n', 'v' }, '<leader>gB', function()
  Snacks.gitbrowse()
end, { desc = 'Git browse' })

-- Delete without yanking
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"_d', {
  desc = 'Delete to black hole register',
})

-- ========================================================================== --
-- ==                            COMPLETION                                == --
-- ========================================================================== --

require('blink.cmp').setup({
  keymap = { preset = 'default' },
  appearance = {
    nerd_font_variant = 'mono',
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
})

-- ========================================================================== --
-- ==                            FORMATTING                                == --
-- ========================================================================== --

require('conform').setup({
  formatters_by_ft = {
    python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format'},
    terraform = { 'terraform_fmt' },
    go = { 'goimports', 'gofmt', stop_after_first = true },
    rust = { 'rustfmt' },
    lua = { 'stylua' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },
    sh = { 'shfmt' },
    bash = { 'shfmt' },
    sql = { 'sqlfluff' },
  },
  format_on_save = {
    timeout_ms = 1000,
    lsp_format = 'fallback',
  },
})

vim.keymap.set({ 'n', 'x' }, '<leader>cf', function()
  require('conform').format({
    async = true,
    lsp_format = 'fallback',
  })
end, { desc = 'Format' })

-- ========================================================================== --
-- ==                            TREESITTER                                == --
-- ========================================================================== --

local ts_parsers = {
  'lua',
  'vim',
  'vimdoc',
  'c',
  'query',
  'python',
  'go',
  'gomod',
  'gosum',
  'gotmpl',
  'rust',
  'terraform',
  'hcl',
  'json',
  'jsonc',
  'yaml',
  'dockerfile',
  'bash',
  'markdown',
  'markdown_inline',
  'toml',
  'sql',
}

local configs = require('nvim-treesitter.configs')

configs.setup({
  ensure_installed = ts_parsers,
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
})

-- ========================================================================== --
-- ==                              LSP SETUP                               == --
-- ========================================================================== --

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = { buffer = event.buf }

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gr', function()
      Snacks.picker.lsp_references()
    end, { desc = 'References' })

    vim.keymap.set('n', '<leader>ss', function()
      Snacks.picker.lsp_symbols()
    end, { desc = 'Document symbols' })

    vim.keymap.set('n', '<leader>sS', function()
      Snacks.picker.lsp_workspace_symbols()
    end, { desc = 'Workspace symbols' })


    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, {
      desc = 'Rename symbol',
    }))

    vim.keymap.set({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, {
      desc = 'Code action',
    }))

    vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)

    vim.keymap.set('n', '[d', function()
      vim.diagnostic.jump({ count = -1 })
    end, opts)

    vim.keymap.set('n', ']d', function()
      vim.diagnostic.jump({ count = 1 })
    end, opts)
  end,
})

vim.diagnostic.config({
  virtual_text = {
    source = 'if_many',
    spacing = 2,
  },
  float = {
    source = true,
    border = 'rounded',
  },
  severity_sort = true,
  signs = true,
  underline = true,
})

-- ========================================================================== --
-- ==                           LSP SERVERS                                == --
-- ========================================================================== --

-- Enable blink to get completions from LSPs
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(nil, true),
})

-- Lua: lua-language-server
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {
          'vim',
          'Snacks',
        },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
vim.lsp.enable('lua_ls')

-- Python: pyright
-- uv tool install pyright
-- vim.lsp.config('pyright', {
--   settings = {
--     pyright = {
--       disableOrganizeImports = true,
--     },
--     python = {
--       analysis = {
--         ignore = { '*' }, -- Ruff handles diagnostics
--       },
--     },
--   },
-- })

vim.lsp.config('pyright', {
  settings = {
    pyright = {
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        typeCheckingMode = 'basic',
        diagnosticMode = 'workspace',
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})
vim.lsp.enable('pyright')

-- Python: ruff for linting and formatting
-- uv tool install ruff
vim.lsp.enable('ruff')

-- Terraform: terraform-ls
-- https://www.hashicorp.com/en/official-packaging-guide
vim.lsp.enable('terraformls')

-- YAML: yaml-language-server
-- npm install -g yaml-language-server
vim.lsp.config('yamlls', {
  settings = {
    yaml = {
      schemastore = { enable = false },
      validate = true,
      schemaStore = {
        enable = false,
        url = '',
      },
      schemas = vim.tbl_extend(
        'force',
        require('schemastore').yaml.schemas(),
        {
          ['https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json'] = {
            'azure-pipelines.yml',
            '/*.azure-pipelines.yml',
            'az-pipeline.yml',
            'azure-pipelines.yaml',
            '**/cicd/*.yml',
            '**/cicd/*.yaml',
            '**/.cicd/*.yml',
            '**/.cicd/*.yaml',
            '**/pipelines/*.yml',
            '**/pipelines/*.yaml',
            '**/.azuredevops/*.yaml',
            '**/.azuredevops/*.yml',
          },
          ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = {
            'docker-compose*.yml',
            'docker-compose*.yaml',
            'compose.yml',
            'compose.yaml',
          },
        }
      ),
    },
  },
})
vim.lsp.enable('yamlls')

-- Dockerfile: dockerfile-language-server
-- npm install -g dockerfile-language-server-nodejs
vim.lsp.enable('dockerls')

-- JSON: vscode-json-language-server
-- npm install -g vscode-langservers-extracted
vim.lsp.config('jsonls', {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})
vim.lsp.enable('jsonls')

-- Go: gopls
-- go install golang.org/x/tools/gopls@latest
vim.lsp.config('gopls', {
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
})
vim.lsp.enable('gopls')

-- Rust: rust-analyzer
-- rustup component add rust-analyzer rustfmt clippy rust-src
vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      cargo = {
        allFeatures = true,
      },
    },
  },
})
vim.lsp.enable('rust_analyzer')
