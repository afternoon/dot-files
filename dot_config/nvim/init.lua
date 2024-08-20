--
-- @afternoon's neovim config 2024
--

--
-- OPTIONS
--

-- enable mouse in all modes
vim.opt.mouse = "a"

-- show line numbers
vim.opt.number = true

-- tabs to spaces
vim.opt.expandtab = true

-- sane indentation
local tabstop = 2
vim.opt.tabstop = tabstop
vim.opt.shiftwidth = tabstop
vim.opt.softtabstop = tabstop

-- ignore case when searching
vim.opt.ignorecase = true

-- global substitute default on
vim.opt.gdefault = true

-- highlight matching bracket
vim.opt.showmatch = true

-- disable line wrapping
vim.opt.wrap = false

-- autoread files changed outside vim
vim.opt.autoread = true

-- write files when moving around file lists
vim.opt.autowrite = true
vim.opt.autowriteall = true

-- always show sign column
vim.opt.signcolumn = "yes"

-- use ripgrep for :grep
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"

-- show color column
vim.opt.textwidth = 100
vim.opt.colorcolumn = "101"
vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg=7, bg="#111111" })

--
-- KEYBINDINGS
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
vim.g.mapleader = ","

-- use <§> as <Esc> because my silly Apple laptop has a silly DouchBar
map {"n", "§", "<Esc>"}
map {"v", "§", "<Esc>gV"}
map {"o", "§", "<Esc>"}
map {"c", "§", "<C-c><Esc>"}
map {"i", "§", "<Esc>`^"}

-- Normal mode

-- window splitting, closing, moving
map {"n", "<Leader>v", "<C-w>v<C-w>l"}
map {"n", "<Leader>s", "<C-w>s<C-w>j"}
map {"n", "<Leader>c", "<C-w>c"}
map {"n", "<C-h>", "<C-w>h"}
map {"n", "<C-j>", "<C-w>j"}
map {"n", "<C-k>", "<C-w>k"}
map {"n", "<C-l>", "<C-w>l"}

-- move between buffers with J/K
map {"n", "<S-l>", ":bnext<CR>"}
map {"n", "<S-h>", ":bprev<CR>"}

-- shortcuts for deleting, saving, etc
map {"n", "<Leader>q", ":wqa!<CR>"}
map {"n", "<Leader>w", ":w!<CR>"}
map {"n", "<Leader><Esc>", ":q!<CR>"}
map {"n", "<Leader>d", ":bd!<CR>"}
map {"n", "<Leader>D", ":bufdo bd<CR>"}

-- telescope
map {"n", "<Leader>f", ":Telescope find_files<CR>"}
map {"n", "<Leader>g", ":Telescope live_grep<CR>"}
map {"n", "<Leader>b", ":Telescope buffers<CR>"}

-- hide search highlighting
map {"n", "<Leader>l", ":nohlsearch<CR>"}

-- open/close quickfix window
map {"n", "<Leader>z", ":copen<CR>"}
map {"n", "<Leader>x", ":cclose<CR>"}

-- toggle file tree view
map {"n", "<Leader><Space>", ":NvimTreeToggle<CR>"}

-- show search results in the centre of the window
map {"n", "n", "nzz"}
map {"n", "N", "Nzz"}
map {"n", "*", "*zz"}
map {"n", "#", "#zz"}
map {"n", "g*", "g*zz"}
map {"n", "g#", "g#zz"}

-- Visual mode

-- keep visual selection after indent
map {"v", ">", ">gv"}
map {"v", "<", "<gv"}

-- don"t overwrite register when replacing a selection
map {"v", "p", '"_dP'}

-- sort visual selection
map {"v", "<Leader>s", ":sort<CR>"}

--
-- Bootstrap lazy.nvim
--

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- fancy colorscheme
    {
      "navarasu/onedark.nvim",
      lazy = false,
      priority = 1000,
      opts = {
        style = "darker"
      },
      config = {
        require("onedark").load()
      }
    },

    -- fancy bracket completion
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = true
    },

    -- fancy fuzzy finding
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.8",
      dependencies = { "nvim-lua/plenary.nvim" }
    },

    -- tpope: Vim plugin artist
    { "tpope/vim-abolish" },
    { "tpope/vim-commentary" },
    { "tpope/vim-repeat" },
    { "tpope/vim-surround" },
    { "tpope/vim-unimpaired" },

    -- auto-save
    { "pocco81/auto-save.nvim" },

    -- file tree viewer
    {
      "kyazdani42/nvim-tree.lua",
      dependencies = { "kyazdani42/nvim-web-devicons" }
    },

    -- git info in gutter
    {
      "lewis6991/gitsigns.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- syntax highlight EVERYTHING
    { "nvim-treesitter/nvim-treesitter" },
    { "sheerun/vim-polyglot" },

    -- highlight/strip trailing whitespace
    { "ntpeters/vim-better-whitespace" },

    -- lsp-zero v4
    { "VonHeikemen/lsp-zero.nvim", branch = "v4.x", lazy = false },
    { "neovim/nvim-lspconfig", lazy = false },

    -- language server management
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },

    -- completion + snippets
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        { 'L3MON4D3/LuaSnip', version = "v2.*" },
        { "saadparwaiz1/cmp_luasnip" },
        { 'rafamadriz/friendly-snippets' },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },
        { "hrsh7th/cmp-path" },
      },
      config = function()
        local cmp = require("cmp")
        local cmp_action = require("lsp-zero").cmp_action()

        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
          sources = {
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "luasnip" },
            { name = "path" },
            { name = "buffer" },
          },
          mapping = cmp.mapping.preset.insert({
            -- `Enter` key to confirm completion
            ["<CR>"] = cmp.mapping.confirm({select = false}),

            -- supertab
            ["<Tab>"] = cmp_action.luasnip_supertab(),
            ["<S-Tab>"] = cmp_action.luasnip_shift_supertab(),

            -- Ctrl+Space to trigger completion menu
            ["<C-Space>"] = cmp.mapping.complete(),

            -- Navigate between snippet placeholder
            ["<C-f>"] = cmp_action.vim_snippet_jump_forward(),
            ["<C-b>"] = cmp_action.vim_snippet_jump_backward(),
          }),
          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          },
        })
      end
    },

    -- lsp-zero
    -- {
    --   'VonHeikemen/lsp-zero.nvim',
    --   branch = 'v4.x',
    --   lazy = true,
    --   config = false,
    -- },

    -- mason to install language servers
    -- {
    --   'williamboman/mason.nvim',
    --   lazy = false,
    --   config = true,
    -- },

    -- LSPconfig
    --{
    --  'neovim/nvim-lspconfig',
    --  cmd = {'LspInfo', 'LspInstall', 'LspStart'},
    --  event = {'BufReadPre', 'BufNewFile'},
    --  dependencies = {
    --    -- Mason to install language servers
    --    { 'williamboman/mason-lspconfig.nvim' },

    --    -- Autocompletion
----        {
----          'hrsh7th/nvim-cmp',
----          event = 'InsertEnter',
----          dependencies = {
----  	    { 'hrsh7th/cmp-buffer' },
----	    { 'hrsh7th/cmp-nvim-lsp' },
----	    { 'hrsh7th/cmp-nvim-lua' },
----	    { 'hrsh7th/cmp-path' },
----	    { 'saadparwaiz1/cmp_luasnip' },
----            { 'L3MON4D3/LuaSnip', version = "v2.*" },
----            { 'rafamadriz/friendly-snippets' }
----          },
----          config = function()
----            local cmp = require('cmp')
----
----            require('luasnip.loaders.from_vscode').lazy_load()
----
----            cmp.setup({
----              sources = {
----                { name = 'nvim_lsp' },
----                { name = 'nvim_lua' },
----                { name = 'luasnip' },
----                { name = 'path' },
----                { name = 'buffer' },
----              },
----              mapping = cmp.mapping.preset.insert({
----                ['<C-Space>'] = cmp.mapping.complete(),
----                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
----                ['<C-d>'] = cmp.mapping.scroll_docs(4),
----              }),
----              snippet = {
----                expand = function(args)
----                  vim.snippet.expand(args.body)
----                end,
----              },
----            })
----          end
----        },
    --  },
    --  config = function()
    --    local lsp_zero = require('lsp-zero')

    --    -- lsp_attach is where you enable features that only work
    --    -- if there is a language server active in the file
    --    local lsp_attach = function(client, bufnr)
    --      local opts = { buffer = bufnr }

    --      vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    --      vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    --      vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    --      vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    --      vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    --      vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    --      vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    --      vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    --      vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    --      vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    --    end

    --    lsp_zero.extend_lspconfig({
    --      sign_text = true,
    --      lsp_attach = lsp_attach,
    --      capabilities = require('cmp_nvim_lsp').default_capabilities()
    --    })

    --    require('mason-lspconfig').setup({
    --      ensure_installed = {},
    --      handlers = {
    --        -- this first function is the "default handler"
    --        -- it applies to every language server without a "custom handler"
    --        function(server_name)
    --          require('lspconfig')[server_name].setup({})
    --        end,
    --      }
    --    })
    --  end
    --}
  },

  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = {
    colorscheme = { "onedark" }
  },

  -- automatically check for plugin updates
  checker = {
    enabled = true
  },
})

local lsp_zero = require("lsp-zero")

-- lsp_attach is where you enable features that only work
-- if there is a language server active in the file
local lsp_attach = function(client, bufnr)
  local opts = {buffer = bufnr}

  vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
  vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
  vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
  vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
  vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
  vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
  vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
  vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
  vim.keymap.set({"n", "x"}, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
  vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
end

lsp_zero.extend_lspconfig({
  sign_text = true,
  lsp_attach = lsp_attach,
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

require("mason").setup({})
require("mason-lspconfig").setup({
  handlers = {
    function(server_name)
      require("lspconfig")[server_name].setup({})
    end,
  },
})
