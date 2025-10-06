-- ===================================================================
---@diagnostic disable: undefined-global
-- Neovim init.lua — full config with lazy.nvim, which-key (spec),
-- lualine (powerline arrows), Telescope, nvim-tree, LSP (0.11 API),
-- completion, Git, and *all your original mappings with comments*.
-- ===================================================================

--
-- 0) Bootstrap lazy.nvim -------------------------------------------------
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--
-- 1) Core Options --------------------------------------------------------
--
vim.g.mapleader = " "                               -- Space as <leader>

-- UI
vim.opt.number = true                               -- Absolute line numbers
vim.opt.relativenumber = true                       -- Relative line numbers
vim.opt.numberwidth = 4                             -- Number column width
vim.opt.termguicolors = true                        -- 24-bit colors
vim.opt.cursorline = true                           -- Highlight current line
vim.opt.signcolumn = "yes"                          -- Stable sign column
vim.opt.wrap = false                                -- Don't wrap long lines
vim.opt.scrolloff = 10                              -- Keep context around cursor
vim.opt.showmode = false                            -- Hide -- INSERT -- (statusline will show)
vim.opt.mouse = "a"                                 -- Mouse support
vim.opt.clipboard = "unnamedplus"                   -- System clipboard

-- Editing
vim.opt.expandtab = true                            -- Tabs -> spaces
vim.opt.tabstop = 2                                 -- Visual width of tabs
vim.opt.softtabstop = 2                             -- <Tab> in insert mode
vim.opt.shiftwidth = 2                              -- Indent width
vim.opt.smartindent = true                          -- Smart indent

-- Search
vim.opt.incsearch = true                            -- Incremental search
vim.opt.hlsearch = false                            -- Don't persist highlights
vim.opt.ignorecase = true                           -- Case-insensitive by default
vim.opt.smartcase = true                            -- ...unless query has capitals

-- Windows / Buffers
vim.opt.splitbelow = true                           -- New horizontal splits go below
vim.opt.splitright = true                           -- New vertical splits go right
vim.opt.hidden = true                               -- Switch buffers without saving

-- Undo / Backups
vim.opt.swapfile = false                            -- No swap files
vim.opt.backup = false                              -- No backups
vim.opt.undofile = true                             -- Persistent undo
vim.opt.undodir = "~/.config/nvim/undodir"

-- Perf
vim.opt.updatetime = 250                            -- Faster UI updates

--
-- 2) Plugins via lazy.nvim ------------------------------------------------
--
require("lazy").setup({
  -- THEME ----------------------------------------------------------------
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
  { "echasnovski/mini.icons", version = "*", opts = {} },

  -- STATUSLINE (with powerline arrows) -----------------------------------
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "onedark",
        globalstatus = true,
        section_separators = { left = "", right = "" }, -- Powerline arrows
        component_separators = { left = "", right = "" }, -- Thin separators
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

  -- FILE EXPLORER --------------------------------------------------------
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

  -- FUZZY FINDING (Telescope + native fzf) -------------------------------
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = function() return vim.fn.executable("make") == 1 end },
    },
    config = function()
      local t = require("telescope")
      t.setup({})
      pcall(t.load_extension, "fzf")
    end,
  },

  -- GIT ------------------------------------------------------------------
  { "lewis6991/gitsigns.nvim", opts = {} },
  -- LazyGit (floating window like Telescope)
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitCurrentFile", "LazyGitConfig" },
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_floating_window_scaling_factor = 0.95
      vim.g.lazygit_floating_window_border_chars = { "╭","─","╮","│","╯","─","╰","│" }
      vim.g.lazygit_use_neovim_remote = 1
    end,
  },            -- sign column hunks

  -- EDITING QUALITY OF LIFE ----------------------------------------------
  { "numToStr/Comment.nvim", opts = {} },              -- gc, gcc comments
  { "kylechui/nvim-surround", version = "*", opts = {} },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  -- LSP (Neovim 0.11+ API via vim.lsp.config) ----------------------------
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", build = ":MasonUpdate", opts = {} },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "ts_ls", "pyright", "bashls", "jsonls", "yamlls",
        },
        handlers = {
          -- default handler for installed servers
          function(server)
            if vim.lsp.config[server] then
              vim.lsp.config[server].setup({ capabilities = capabilities })
            end
          end,
          -- custom Lua settings so it knows `vim` global
          lua_ls = function()
            vim.lsp.config.lua_ls.setup({
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = { globals = { "vim" } },
                  workspace = { checkThirdParty = false },
                },
              },
            })
          end,
        },
      })
    end,
  },

  -- COMPLETION -----------------------------------------------------------
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
        sources = { { name = "nvim_lsp" }, { name = "path" }, { name = "buffer" }, { name = "luasnip" } },
      })
    end,
  },

  -- WHICH-KEY (modern spec) ---------------------------------------------
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix", -- visuals; change to "classic" if preferred
      plugins = {
        marks = true,
        registers = true,
        spelling = { enabled = true, suggestions = 20 },
      },
      win = { border = "rounded", title = "which-key", title_pos = "center" },
      layout = { spacing = 6, align = "left" },
      spec = {
        -- Group labels for your leader menus and common prefixes
        { "<leader>f",  group = "file/find",            mode = { "n", "v" } },
        { "<leader>g",  group = "git",                  mode = { "n", "v" } },
        { "<leader>b",  group = "buffers",              mode = { "n", "v" } },
        { "<leader>w",  group = "windows", proxy = "<c-w>", mode = { "n" },
          expand = function() return require("which-key.extras").expand.win() end },
        { "<leader>t",  group = "tabs",                 mode = { "n" } },
        { "<leader>s",  group = "splits",               mode = { "n" } },
        { "<leader>u",  group = "ui",                   mode = { "n" } },
        { "<leader>x",  group = "diagnostics",          mode = { "n" } },
        { "<leader>e",  group = "explorer",             mode = { "n" } },
        { "g",          group = "goto",                 mode = { "n", "v" } },
        { "z",          group = "fold",                 mode = { "n" } },
        { "[",          group = "prev",                 mode = { "n" } },
        { "]",          group = "next",                 mode = { "n" } },
        { "gx",         desc  = "Open with system app",  mode = { "n" } },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Show buffer-local keymaps" },
      { "<c-w><space>", function() require("which-key").show({ keys = "<c-w>", loop = true }) end, desc = "Window keymap helper" },
    },
  },
}, {
  ui = { border = "rounded" },
})

--
-- 3) Your Keymaps (with comments) ----------------------------------------
--
local map = vim.keymap.set

-- Show which-key popup (just examples above use automatic triggers)
-- map("n", "<leader>", "<cmd>WhichKey '<Space>'<CR>", { desc = "Show leader keymaps" }) -- not needed normally

-- Quick exit from insert/visual using "kj"
map("i", "kj", "<Esc>", { desc = "Exit insert mode" })
map("v", "kj", "<Esc>", { desc = "Exit visual mode" })

-- File Explorer: toggle nvim-tree
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Increment / Decrement numbers with leader
map("n", "<leader>+", "<C-a>", { desc = "Increment number" })
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Buffer Management
map("n", "<leader>bo", "<cmd>enew<CR>",       { desc = "New empty buffer" })
map("n", "<leader>bx", "<cmd>bwipeout<CR>",   { desc = "Wipe buffer" })
map("n", "<leader>bn", "<cmd>bnext<CR>",      { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>",  { desc = "Previous buffer" })
map("n", "<leader>bl", "<cmd>ls<CR>",         { desc = "List buffers" })

-- Window / Split Management
map("n", "<leader>sv", "<C-w>v",              { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s",              { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=",              { desc = "Equalize window sizes" })
map("n", "<leader>sx", "<cmd>close<CR>",      { desc = "Close current window" })

-- Tab Management
map("n", "<leader>to", "<cmd>tabnew<CR>",     { desc = "New tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>",   { desc = "Close tab" })
map("n", "<leader>tn", "<cmd>tabnext<CR>",    { desc = "Next tab" })
map("n", "<leader>tp", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "<leader>tb", "<cmd>tab split<CR>",   { desc = "Open buffer in new tab" })

-- Move between buffers (Shift+h/l) and with Shift+Arrows
map("n", "<S-h>", ":bprevious<CR>",           { desc = "Previous buffer" })
map("n", "<S-l>", ":bnext<CR>",               { desc = "Next buffer" })
map("n", "<S-Left>",  ":bprevious<CR>",       { desc = "Previous buffer (arrow)" })
map("n", "<S-Right>", ":bnext<CR>",           { desc = "Next buffer (arrow)" })

-- Pane / Window Navigation with hjkl and arrows
map("n", "<C-h>", "<C-w>h",                    { desc = "Go to left pane" })
map("n", "<C-j>", "<C-w>j",                    { desc = "Go to lower pane" })
map("n", "<C-k>", "<C-w>k",                    { desc = "Go to upper pane" })
map("n", "<C-l>", "<C-w>l",                    { desc = "Go to right pane" })
map("n", "<C-Left>",  "<C-w>h",                { desc = "Go to left pane (arrow)" })
map("n", "<C-Down>",  "<C-w>j",                { desc = "Go to lower pane (arrow)" })
map("n", "<C-Up>",    "<C-w>k",                { desc = "Go to upper pane (arrow)" })
map("n", "<C-Right>", "<C-w>l",                { desc = "Go to right pane (arrow)" })

-- Telescope pickers (replacing fzf.vim usage)
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>",    { desc = "Find buffers" })

-- Center screen after motions/search
map("n", "n", "nzzzv",                      { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv",                      { desc = "Previous search result (centered)" })
map("n", "<C-d>", "<C-d>zz",                { desc = "Half-page down (centered)" })
map("n", "<C-u>", "<C-u>zz",                { desc = "Half-page up (centered)" })

-- Resize windows with Ctrl+Arrows
map("n", "<C-Up>",    ":resize +2<CR>",           { desc = "Increase window height" })
map("n", "<C-Down>",  ":resize -2<CR>",           { desc = "Decrease window height" })
map("n", "<C-Left>",  ":vertical resize -2<CR>",  { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>",  { desc = "Increase window width" })

-- LazyGit shortcuts (floating window)
map("n", "<leader>gg", "<cmd>LazyGit<CR>",               { desc = "LazyGit (float)" })
map("n", "<leader>gF", "<cmd>LazyGitCurrentFile<CR>",    { desc = "LazyGit current file" })

-- Which-key helpers in a window (Telescope-like UX)
map("n", "<leader>wk", function() require("which-key").show({ keys = "<leader>", loop = true }) end, { desc = "Which-key: Leader menu" })

-- Optional: Gitsigns hunk helpers (comment out if you don't want them)
-- map("n", "]h", function() require("gitsigns").nav_hunk("next") end, { desc = "Next git hunk" })
-- map("n", "[h", function() require("gitsigns").nav_hunk("prev") end, { desc = "Prev git hunk" })
-- map("n", "<leader>hs", function() require("gitsigns").stage_hunk() end, { desc = "Stage hunk" })
-- map("n", "<leader>hu", function() require("gitsigns").undo_stage_hunk() end, { desc = "Undo stage hunk" })

--
-- 4) Autocommands --------------------------------------------------------
--
-- Remove trailing whitespace on save (preserve view)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

