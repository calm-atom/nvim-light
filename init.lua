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
MiniDeps.add('oskarnurm/koda.nvim')
MiniDeps.add({
  source = 'zenbones-theme/zenbones.nvim',
  depends = { 'rktjmp/lush.nvim' },
})
MiniDeps.add({
  source = 'nvim-mini/mini.nvim',
  checkout = mini.branch,
})

-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --
vim.cmd.colorscheme('rosebones')
