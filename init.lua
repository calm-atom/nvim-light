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

-- Basic clipboard interaction
vim.keymap.set({'n', 'x'}, 'gy', '"+y', {desc = 'Copy to clipboard'})
vim.keymap.set({'n', 'x'}, 'gp', '"+p', {desc = 'Paste clipboard content'})

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --
vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'execute plugin callbacks',
  callback = function(event)
    local data = event.data or {}
    local kind = data.kind or ''
    local callback = vim.tbl_get(data, 'spec', 'data', 'on_' .. kind)

    if type(callback) ~= 'function' then
      return
    end

    -- possible callbacks: on_install, on_update, on_delete
    local ok, err = pcall(callback, data)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end,
})

vim.pack.add({
  {src = 'https://github.com/neovim/nvim-lspconfig'},
  {src = 'https://github.com/nvim-mini/mini.nvim', version = 'main'},
})
