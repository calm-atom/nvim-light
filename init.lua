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

--- Enable 24-bit colors
--- Required when working via SSH
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

MiniDeps.add({source = 'folke/flash.nvim',})

MiniDeps.add({
  source = 'nvim-treesitter/nvim-treesitter',
  checkout = 'master',
  hooks = {
    post_checkout = function()
      vim.cmd.TSUpdate()
    end,
  },
})

MiniDeps.add({
  source = "saghen/blink.cmp",
  depends = { "rafamadriz/friendly-snippets" },
  checkout = "v1.10.1",
})

MiniDeps.add({ source = "b0o/SchemaStore.nvim" })

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

require('flash').setup({
  modes = {
    char = { jump_labels = true }
  }
})
vim.keymap.set({'n', 'x', 'o'}, 's', function() require('flash').jump() end, {desc = 'Flash jump'}) 
vim.keymap.set({'n', 'x', 'o'}, 'S', function() require('flash').treesitter() end, {desc = 'Flash treesitter selection'}) 


require('mini.diff').setup({
  view = {
    style = 'sign',
    signs = { add = '+', change = '~', delete='-'},
  }
})
vim.keymap.set('n', '<leader>go', '<cmd>lua MiniDiff.toggle_overlay()<cr>', {desc = 'Toggle inline Git diff'})

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
vim.keymap.set('n', '<leader>gc', '<cmd>Pick git_commits<cr>', {desc = 'Search Git commits'})
vim.keymap.set('n', '<leader>gb', '<cmd>Pick git_branches<cr>', {desc = 'Search Git branches'})
vim.keymap.set('n', '<leader>gm', '<cmd>Pick git_files scope="modified"<cr>', {desc = 'Search modified files'})


require('mini.statusline').setup({})
require('mini.extra').setup({})

-- Completion and snippets
require('blink.cmp').setup({
  keymap = { preset = 'default' },
  appearance = {
    nerd_font_variant = 'mono',
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
})

local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },
    { mode = 'n', keys = ']' },
    { mode = 'x', keys = ']' },
    { mode = 'n', keys = '[' },
    { mode = 'x', keys = '[' },
  },
  clues = {
    miniclue.gen_clues.g(),
    miniclue.gen_clues.z(),
    miniclue.gen_clues.windows(),
    { mode = 'n', keys = '<Leader>e', desc = 'File Explorer' },
    { mode = 'n', keys = '<Leader>f', desc = '+Find' },
    { mode = 'n', keys = '<Leader>g', desc = '+Git' },
  },
  window = { delay = 300 }
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
local configs = require('nvim-treesitter.configs')
configs.setup({
  ensure_installed = ts_parsers,
  auto_install = true,
  highlight = { enable = true },
  indent = {enable = true },
})

-- LSP setup
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'grd', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)

    -- Diagnostic keymaps
    vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)

    local id = vim.tbl_get(event, 'data', 'client_id')
    local client = id and vim.lsp.get_client_by_id(id)

  end,
})

-- ========================================================================== --
-- ==                           LSP SERVERS                                == --
-- ========================================================================== --
-- Enable blink to get completions from LSPs
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(nil, true)
})

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
      schemastore = { enable = false },
      validate = true,
      schemas = {
        ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
          "azure-pipelines.yml",
          "/*.azure-pipelines.yml",
          "az-pipeline.yml",
          "azure-pipelines.yaml",
          "**/cicd/*.yml",
          "**/cicd/*.yaml",
          "**/.cicd/*.yml",
          "**/.cicd/*.yaml",
          "**/pipelines/*.yml",
          "**/pipelines/*.yaml",
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

-- Dockerfile: dockerfile-language-server
-- npm install -g dockerfile-language-server-nodejs
vim.lsp.enable('dockerls')

-- JSON: vscode-json-language-server
-- npm install -g vscode-langservers-extracted
vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})
vim.lsp.enable("jsonls")
