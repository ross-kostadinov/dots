-- ===================================================================
-- Neovim init.lua — Full config with lazy.nvim, which-key (spec),
-- lualine (powerline arrows), Telescope, nvim-tree, LSP (0.11 API),
-- completion, Git, and ALL your mappings with comments.
---@diagnostic disable: undefined-global
-- ===================================================================

-- 0) Bootstrap lazy.nvim ---------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 1) Core Options ----------------------------------------------------------
vim.g.mapleader = " "  -- Space as <leader>

-- UI
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.showmode = false
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

-- Editing / Indent
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

-- Search
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Windows / Buffers
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.hidden = true

-- Undo / Backups
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = "~/config/nvim/undodir"

-- Performance
vim.opt.updatetime = 250

-- 2) Plugins via lazy.nvim -------------------------------------------------
require("lazy").setup({
  -- Theme
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "darker" },
    config = function(_, opts)
      require("onedark").setup(opts)
      require("onedark").load()
    end,
  },

  -- Icons (which-key health likes this)
  { "echasnovski/mini.icons", version = "*", opts = {} },
  { "nvim-tree/nvim-web-devicons" },

  -- Statusline (with powerline arrows)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "onedark",
        globalstatus = true,
        section_separators   = { left = "", right = "" }, -- arrows
        component_separators = { left = "", right = "" }, -- thin separators
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "progress", "location" },
      },
    },
  },

  -- File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    opts = {
      view = { width = 36 },
      renderer = { group_empty = true },
      filters = { dotfiles = false },
      git = { enable = true },
      hijack_cursor = true,
    },
  },

  -- Telescope + native FZF
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make",
        cond = function() return vim.fn.executable("make") == 1 end },
    },
    config = function()
      local t = require("telescope")
      t.setup({})
      pcall(t.load_extension, "fzf")
    end,
  },

  -- Git
  "tpope/vim-fugitive",
  { "rbong/vim-flog", cmd = { "Flog", "Flogsplit" } },
  { "lewis6991/gitsigns.nvim", opts = {} },

  -- Editing QoL
  { "numToStr/Comment.nvim", opts = {} },
  { "kylechui/nvim-surround", version = "*", opts = {} },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  -- LSP (Neovim 0.11 API + fallback)
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", build = ":MasonUpdate", opts = {} },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local has_new = vim.lsp and vim.lsp.config
      local function lsp_setup(server, opts)
        opts = opts or {}
        opts.capabilities = capabilities
        if has_new and vim.lsp.config[server] then
          vim.lsp.config[server].setup(opts)
        else
          require("lspconfig")[server].setup(opts)
        end
      end

      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "pyright", "gopls", "bashls", "jsonls", "yamlls" },
        handlers = {
          function(server) lsp_setup(server, {}) end,
          lua_ls = function()
            lsp_setup("lua_ls", {
              settings = {
                Lua = {
                  diagnostics = { globals = { 'vim' } },
                  workspace = { checkThirdParty = false },
                },
              },
            })
          end,
        },
      })
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
          { name = "luasnip" },
        },
      })
    end,
  },

  -- which-key (modern spec)  ---------------------------------------------
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      plugins = {
        marks = true,
        registers = true,
        spelling = { enabled = true, suggestions = 20 },
      },
      win = { border = "single" },  -- NOTE: 'win' replaces deprecated 'window'
      layout = { spacing = 6, align = "left" },
      spec = {
        -- Groups/prefixes (flat spec entries are simplest & robust)
        { "<leader>f",  group = "file/find",        mode = { "n", "v" } },
        { "<leader>g",  group = "git",              mode = { "n", "v" } },
        { "<leader>b",  group = "buffers",          mode = { "n", "v" } },
        { "<leader>w",  group = "windows",          mode = "n", proxy = "<c-w>",
          expand = function() return require("which-key.extras").expand.win() end },
        { "<leader>t",  group = "tabs",             mode = "n" },
        { "<leader>s",  group = "splits",           mode = "n" },
        { "<leader>u",  group = "ui",               mode = "n" },
        { "<leader>x",  group = "diagnostics",      mode = "n" },
        { "<leader>e",  group = "explorer",         mode = "n" },
        { "g",          group = "goto",             mode = { "n", "v" } },
        { "z",          group = "fold",             mode = "n" },
        { "[",          group = "prev",             mode = "n" },
        { "]",          group = "next",             mode = "n" },
        { "gx",         desc  = "Open with system app", mode = "n" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end,
        desc = "Show buffer-local keymaps" },
      { "<c-w><space>", function() require("which-key").show({ keys = "<c-w>", loop = true }) end,
        desc = "Window keymap helper" },
    },
  },
}, {
  ui = { border = "rounded" },
})

-- 3) Your Keymaps (all with comments + desc) ------------------------------
local map = vim.keymap.set

-- Quick escape using "kj"
map("i", "kj", "<Esc>", { desc = "Exit insert mode" })
map("v", "kj", "<Esc>", { desc = "Exit visual mode" })

-- File explorer
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Increment/Decrement numbers
map("n", "<leader>+", "<C-a>", { desc = "Increment number" })
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Buffer Management
map("n", "<leader>bo", "<cmd>enew<CR>",      { desc = "New empty buffer" })
map("n", "<leader>bx", "<cmd>bwipeout<CR>",  { desc = "Wipe buffer" })
map("n", "<leader>bn", "<cmd>bnext<CR>",     { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bl", "<cmd>ls<CR>",        { desc = "List buffers" })

-- Window Management
map("n", "<leader>sv", "<C-w>v",         { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s",         { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=",         { desc = "Equalize window sizes" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current window" })

-- Tab Management
map("n", "<leader>to", "<cmd>tabnew<CR>",      { desc = "New tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>",    { desc = "Close tab" })
map("n", "<leader>tn", "<cmd>tabnext<CR>",     { desc = "Next tab" })
map("n", "<leader>tp", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "<leader>tb", "<cmd>tab split<CR>",   { desc = "Open buffer in new tab" })

-- Move between buffers
map("n", "<S-h>",    "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>",    "<cmd>bnext<CR>",     { desc = "Next buffer" })
map("n", "<S-Left>", "<cmd>bprevious<CR>", { desc = "Previous buffer (arrow)" })
map("n", "<S-Right>","<cmd>bnext<CR>",     { desc = "Next buffer (arrow)" })

-- Pane navigation (hjkl)
map("n", "<C-h>", "<C-w>h", { desc = "Go to left pane" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower pane" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper pane" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right pane" })

-- Pane navigation (arrows)
map("n", "<C-Left>",  "<C-w>h", { desc = "Go to left pane (arrow)" })
map("n", "<C-Down>",  "<C-w>j", { desc = "Go to lower pane (arrow)" })
map("n", "<C-Up>",    "<C-w>k", { desc = "Go to upper pane (arrow)" })
map("n", "<C-Right>", "<C-w>l", { desc = "Go to right pane (arrow)" })

-- Telescope (find files / buffers)
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>",    { desc = "Find buffers" })

-- Center the cursor after motions/search
map("n", "n",     "nzzzv",   { desc = "Next search result (centered)" })
map("n", "N",     "Nzzzv",   { desc = "Previous search result (centered)" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up (centered)" })

-- Resize windows with Ctrl+Arrows
map("n", "<C-Up>",    ":resize +2<CR>",           { desc = "Increase window height" })
map("n", "<C-Down>",  ":resize -2<CR>",           { desc = "Decrease window height" })
map("n", "<C-Left>",  ":vertical resize -2<CR>",  { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>",  { desc = "Increase window width" })

-- Git (Fugitive)
map("n", "<leader>gs", "<cmd>Git<CR>",               { desc = "Git status" })
map("n", "<leader>ga", "<cmd>Gwrite<CR>",            { desc = "Stage current file" })
map("n", "<leader>gc", "<cmd>Git commit<CR>",        { desc = "Git commit" })
map("n", "<leader>gp", "<cmd>Git push<CR>",          { desc = "Git push" })
map("n", "<leader>gP", "<cmd>Git pull --rebase<CR>", { desc = "Git pull --rebase" })
map("n", "<leader>gb", "<cmd>Gblame<CR>",            { desc = "Git blame" })
map("n", "<leader>gd", "<cmd>Gdiffsplit<CR>",        { desc = "Git diff (split)" })

-- 4) Autocommands ---------------------------------------------------------
-- Remove trailing whitespace on save (preserve cursor/view)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

-- 5) Diagnostics UX (optional polish) ------------------------------------
vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = "●" },
  float = { border = "rounded" },
  severity_sort = true,
})
