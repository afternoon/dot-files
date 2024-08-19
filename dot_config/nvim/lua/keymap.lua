--
-- neovim keymap 2022
--

-- possibly unnecessary - https://bit.ly/3KcTPnM
local map = function(key)
  -- get the extra options
  local opts = {noremap = true, silent = true}
  for i, v in pairs(key) do
    if type(i) == 'string' then opts[i] = v end
  end

  -- basic support for buffer-scoped keybindings
  local buffer = opts.buffer
  opts.buffer = nil

  if buffer then
    vim.api.nvim_buf_set_keymap(0, key[1], key[2], key[3], opts)
  else
    vim.api.nvim_set_keymap(key[1], key[2], key[3], opts)
  end
end

-- comma as leader
vim.g.mapleader = ','

-- use <§> as <Esc> because my silly Apple laptop has a silly DouchBar
map {'n', '§', '<Esc>'}
map {'v', '§', '<Esc>gV'}
map {'o', '§', '<Esc>'}
map {'c', '§', '<C-c><Esc>'}
map {'i', '§', '<Esc>`^'}

--
-- NORMAL
--

-- window splitting, closing, moving
map {'n', '<Leader>v', '<C-w>v<C-w>l'}
map {'n', '<Leader>s', '<C-w>s<C-w>j'}
map {'n', '<Leader>c', '<C-w>c'}
map {'n', '<C-h>', '<C-w>h'}
map {'n', '<C-j>', '<C-w>j'}
map {'n', '<C-k>', '<C-w>k'}
map {'n', '<C-l>', '<C-w>l'}

-- move between buffers with J/K
map {'n', '<S-l>', ':bnext<CR>'}
map {'n', '<S-h>', ':bprev<CR>'}

-- shortcuts for deleting, saving, etc
map {'n', '<Leader>q', ':wqa!<CR>'}
map {'n', '<Leader>w', ':w!<CR>'}
map {'n', '<Leader><Esc>', ':q!<CR>'}
map {'n', '<Leader>d', ':bd!<CR>'}
map {'n', '<Leader>D', ':bufdo bd<CR>'}

-- telescope
map {'n', '<Leader>f', ':Telescope find_files<CR>'}
map {'n', '<Leader>g', ':Telescope live_grep<CR>'}
map {'n', '<Leader>b', ':Telescope buffers<CR>'}

-- hide search highlighting
map {'n', '<Leader>l', ':nohlsearch<CR>'}

-- open/close quickfix window
map {'n', '<Leader>z', ':copen<CR>'}
map {'n', '<Leader>x', ':cclose<CR>'}

-- toggle file tree view
map {'n', '<Leader><Space>', ':NvimTreeToggle<CR>'}

-- show search results in the centre of the window
map {'n', 'n', 'nzz'}
map {'n', 'N', 'Nzz'}
map {'n', '*', '*zz'}
map {'n', '#', '#zz'}
map {'n', 'g*', 'g*zz'}
map {'n', 'g#', 'g#zz'}

-- VISUAL MODE

-- keep visual selection after indent
map {'v', '>', '>gv'}
map {'v', '<', '<gv'}

-- don't overwrite register when replacing a selection
map {'v', 'p', '"_dP'}

-- sort visual selection
map {'v', '<Leader>s', ':sort<CR>'}
