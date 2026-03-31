-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --
--
-- Show line numbers
vim.o.number = true

-- Show relative line numbers
vim.opt.relativenumber = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Clear search highlights after submit
vim.o.hlsearch = true

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

-- Enable 24-bit colors
vim.o.termguicolors = true

-- Faster completion
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Reserve space in gutter for signs
vim.o.signcolumn = 'yes'

-- Use rounded borders for windows
vim.o.winborder = 'rounded'

-- Open new split panes to right and below
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Save undo history
vim.o.undofile = true

-- Raise dialog to save current file(s) if operation would fail due to unsaved changes
vim.o.confirm = true

-- Space as leader key
vim.g.mapleader = vim.keycode('<Space>')

-- Use a light background
vim.o.background = 'light'

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
vim.keymap.set({'n', 'x'}, 'gy', '"+y', {desc = 'Copy to clipboard'})
vim.keymap.set({'n', 'x'}, 'gp', '"+p', {desc = 'Paste clipboard content'})

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

local mini = {}

mini.branch = 'main'
mini.packpath = vim.fn.stdpath('data') .. '/site'

function mini.require_deps()
  local mini_path = mini.packpath .. '/pack/deps/start/mini.nvim'

  if not vim.uv.fs_stat(mini_path) then
    print('Installing mini.nvim....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/nvim-mini/mini.nvim',
      string.format('--branch=%s', mini.branch),
      mini_path
    })

    vim.cmd('packadd mini.nvim | helptags ALL')
  end

  local ok, deps = pcall(require, 'mini.deps')
  if not ok then
    return {}
  end

  return deps
end

local MiniDeps = mini.require_deps()
if not MiniDeps.setup then
  return
end

-- See :help MiniDeps.config
MiniDeps.setup({
  path = {
    package = mini.packpath,
  },
})

MiniDeps.add('neovim/nvim-lspconfig')
MiniDeps.add('stevearc/conform.nvim')
MiniDeps.add({
  source = 'zenbones-theme/zenbones.nvim',
  depends = { 'rktjmp/lush.nvim' },
})
MiniDeps.add({
  source = 'NeogitOrg/neogit',
  depends = {
    'nvim-lua/plenary.nvim',
    'sindrets/diffview.nvim',
  },
})
MiniDeps.add({
  source = 'nvim-mini/mini.nvim',
  checkout = mini.branch,
})

MiniDeps.add({
  source = 'nvim-treesitter/nvim-treesitter',
  checkout = 'main',
  hooks = {
    post_checkout = function()
      vim.cmd.TSUpdate()
    end,
  },
})

-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --
vim.cmd.colorscheme('rosebones')

require('mini.icons').setup({})
require('mini.comment').setup({})
require('mini.notify').setup({
  lsp_progress = {enable = false},
})
require('mini.bufremove').setup({})
require('mini.indentscope').setup({})

-- File explorer
local mini_files = require('mini.files')
mini_files.setup({})
vim.keymap.set('n', '<leader>e', function()
  if mini_files.close() then
    return
  end
  mini_files.open()
end, {desc = 'File explorer'})

-- Fuzzy finder
require('mini.pick').setup({})
vim.keymap.set('n', '<leader>?', '<cmd>Pick oldfiles<cr>', {desc = 'Search file history'})
vim.keymap.set('n', '<leader><space>', '<cmd>Pick buffers<cr>', {desc = 'Search open files'})
vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<cr>', {desc = 'Search all files'})
vim.keymap.set('n', '<leader>fg', '<cmd>Pick grep_live<cr>', {desc = 'Search in project'})
vim.keymap.set('n', '<leader>fd', '<cmd>Pick diagnostic<cr>', {desc = 'Search diagnostics'})
vim.keymap.set('n', '<leader>fs', '<cmd>Pick buf_lines<cr>', {desc = 'Buffer local search'})

require('mini.statusline').setup({})
require('mini.extra').setup({})
require('mini.snippets').setup({})
require('mini.completion').setup({
  lsp_completion = {
    source_func = 'omnifunc',
    auto_setup = false,
  },
})

-- Buffer management
vim.keymap.set('n', '<leader>bd', '<cmd>lua MiniBufremove.delete()<cr>', {desc = 'Delete buffer'})

-- Git
require('neogit').setup({
  -- Use mini.pick for selecting items
  integrations = {
    telescope = nil,
    fzf_lua = nil,
    mini_pick = true,
  },
})
vim.keymap.set('n', '<leader>ng', '<cmd>Neogit<cr>', {desc = 'Git (Neogit)'})

-- Formatting
require('conform').setup({
  formatters_by_ft = {
    python = { 'ruff_fix', 'ruff_format', 'ruff_organize_imports' },
    terraform = { 'terraform_fmt' },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
})

-- Treesitter setup
-- NOTE: the list of supported parsers is in the documentation:
-- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
local ts_parsers = {'lua', 'vim', 'vimdoc', 'c', 'query', 'python'}

require('nvim-treesitter').setup({
  ensure_installed = ts_parsers,
  auto_install = true,
})

-- LSP setup
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}
    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'grd', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)

    -- Use conform for formatting
    vim.keymap.set({'n', 'x'}, 'gq', function()
      require('conform').format({ async = true, lsp_format = 'fallback' })
    end, opts)

    -- Diagnostic keymaps
    vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)

    local id = vim.tbl_get(event, 'data', 'client_id')
    local client = id and vim.lsp.get_client_by_id(id)

    if client and client:supports_method('textDocument/completion') then
      vim.bo[event.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    end
  end,
})

-- ========================================================================== --
-- ==                           LSP SERVERS                                == --
-- ========================================================================== --
-- Python: pyright
-- uv tool install pyright
vim.lsp.config('pyright', {
  settings = {
    pyright = {
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        ignore = {'*'},  -- Ruff handles diagnostics
      }
    }
  }
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
      schemas = {
        ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
          "azure-pipelines.yml",
          "/*.azure-pipelines.yml",
          "az-pipeline.yml",
          "azure-pipelines.yaml",
        },
        -- Docker Compose
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
          "docker-compose*.yml",
          "docker-compose*.yaml",
          "compose.yml",
          "compose.yaml",
        },
      }
    }
  }
})
vim.lsp.enable('yamlls')
