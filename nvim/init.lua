-- ===================================================================
-- Neovim config (Lua) — Ross
-- Manager: lazy.nvim
-- ===================================================================

-- ----------------------------
-- Bootstrap lazy.nvim
-- ----------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ----------------------------
-- General Options (Lua)
-- ----------------------------
local o, g = vim.opt, vim.g

o.compatible = false
o.termguicolors = true
o.encoding = "utf-8"
o.mouse = "a"
o.clipboard = "unnamedplus"

-- Performance
o.updatetime = 250

-- UI
o.number = true
o.relativenumber = true
o.numberwidth = 4
o.signcolumn = "yes"      -- keep signs separate from number column (more stable)
o.cursorline = true
o.scrolloff = 10
o.wrap = false
o.showmode = false

-- Tabs / indentation
o.tabstop = 2
o.softtabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

-- Search
o.incsearch = true
o.hlsearch = false
o.ignorecase = true
o.smartcase = true

-- Splits / buffers
o.splitbelow = true
o.splitright = true
o.hidden = true

-- Undo / backup
o.swapfile = false
o.backup = false
o.undofile = true
o.undodir = vim.fn.stdpath("config") .. "/undodir"

-- Leader
g.mapleader = " "

-- ----------------------------
-- Plugins via lazy.nvim
-- ----------------------------
require("lazy").setup({
  -- Theme
  { "navarasu/onedark.nvim", lazy = false, priority = 1000, config = function()
      require("onedark").setup({ style = "darker" })
      require("onedark").load()
    end
  },

  -- Statusline (replacement for airline)
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function()
      require("lualine").setup({
        options = { theme = "onedark", globalstatus = true, component_separators = "", section_separators = "" },
        sections = {
          lualine_x = {}, lualine_y = {}, lualine_z = { { "progress" }, { "location" } },
        },
      })
    end
  },

  -- File explorer (replacement for NERDTree)
  { "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    keys = { { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" } },
    opts = {
      view = { width = 36 },
      renderer = { group_empty = true },
      filters = { dotfiles = false },
      git = { enable = true },
    },
  },

  -- Telescope (replacement for fzf.vim UI; fast and native)
  { "nvim-telescope/telescope.nvim", branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = function()
          return vim.fn.executable("make") == 1
        end
      },
    },
    config = function()
      local t = require("telescope")
      t.setup({})
      pcall(t.load_extension, "fzf")
    end
  },

  -- Which Key
  {  "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- Git integration
  "tpope/vim-fugitive",                     -- keep: best Git porcelain
  { "rbong/vim-flog", cmd = { "Flog", "Flogsplit" } }, -- works great with fugitive
  { "lewis6991/gitsigns.nvim", opts = {} }, -- replacement for gitgutter (faster/neovim-native)

  -- Comments / Surround / Pairs (modern equivalents)
  { "numToStr/Comment.nvim", opts = {} },   -- replacement for vim-commentary
  { "kylechui/nvim-surround", version = "*", opts = {} }, -- replacement for vim-surround
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} }, -- replacement for auto-pairs

  -- Indentation guides (replacement for indentLine)
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  -- Mason + LSP (modern Neovim 0.11+ API)
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "ts_ls", "pyright", "gopls", "bashls", "jsonls", "yamlls",
        },
        handlers = {
          -- Default handler for all servers
          function(server)
            vim.lsp.config[server].setup({
              capabilities = capabilities,
            })
          end,

          -- Lua LS (special config)
          lua_ls = function()
            vim.lsp.config.lua_ls.setup({
              capabilities = capabilities,
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
  { "hrsh7th/nvim-cmp",
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
    end
  },
}, {
  ui = { border = "rounded" }
})

-- ----------------------------
-- Keymaps (with descriptions for which-key)
-- ----------------------------
local map = vim.keymap.set

-- Show which-key for <leader>
map("n", "<leader>", "<cmd>WhichKey '<Space>'<cr>", { desc = "Show leader keymaps" })

-- Leave insert/visual quickly with "kj"
map("i", "kj", "<Esc>", { desc = "Exit insert mode" })
map("v", "kj", "<Esc>", { desc = "Exit visual mode" })

-- File explorer
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })

-- Increment / Decrement numbers
map("n", "<leader>+", "<C-a>", { desc = "Increment number" })
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Buffer management
map("n", "<leader>bo", "<cmd>enew<CR>",       { desc = "New empty buffer" })
map("n", "<leader>bx", "<cmd>bwipeout<CR>",   { desc = "Wipe buffer" })
map("n", "<leader>bn", "<cmd>bnext<CR>",      { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>",  { desc = "Previous buffer" })
map("n", "<leader>bl", "<cmd>ls<CR>",         { desc = "List buffers" })

-- Window management
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize window sizes" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current window" })

-- Tab management
map("n", "<leader>to", "<cmd>tabnew<CR>",  { desc = "New tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>",{ desc = "Close tab" })
map("n", "<leader>tn", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<leader>tp", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "<leader>tb", "<cmd>tab split<CR>", { desc = "Buffer in new tab" })

-- Buffer switching (Shift+h/l and arrows)
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>",     { desc = "Next buffer" })
map("n", "<S-Left>",  "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-Right>", "<cmd>bnext<CR>",     { desc = "Next buffer" })

-- Pane navigation (hjkl and arrows)
map("n", "<C-h>", "<C-w>h", { desc = "Go to left pane" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower pane" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper pane" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right pane" })
map("n", "<C-Left>",  "<C-w>h", { desc = "Go to left pane" })
map("n", "<C-Down>",  "<C-w>j", { desc = "Go to lower pane" })
map("n", "<C-Up>",    "<C-w>k", { desc = "Go to upper pane" })
map("n", "<C-Right>", "<C-w>l", { desc = "Go to right pane" })

-- Telescope (keeps your <leader>ff / <leader>fb habits)
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>",    { desc = "Find buffers" })

-- Center screen after motions/search
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up (centered)" })

-- Resize windows
map("n", "<C-Up>",    ":resize +2<CR>",            { desc = "Increase window height" })
map("n", "<C-Down>",  ":resize -2<CR>",            { desc = "Decrease window height" })
map("n", "<C-Left>",  ":vertical resize -2<CR>",   { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>",   { desc = "Increase window width" })

-- Git (fugitive + gitsigns)
map("n", "<leader>gs", "<cmd>Git<CR>",           { desc = "Git status (fugitive)" })
map("n", "<leader>ga", "<cmd>Gwrite<CR>",        { desc = "Stage current file" })
map("n", "<leader>gc", "<cmd>Git commit<CR>",    { desc = "Git commit" })
map("n", "<leader>gp", "<cmd>Git push<CR>",      { desc = "Git push" })
map("n", "<leader>gP", "<cmd>Git pull --rebase<CR>", { desc = "Git pull --rebase" })
map("n", "<leader>gb", "<cmd>Gblame<CR>",        { desc = "Git blame (fugitive)" })
map("n", "<leader>gd", "<cmd>Gdiffsplit<CR>",    { desc = "Git diff (split)" })

-- Gitsigns hunk navigation (nice to have)
map("n", "]h", function() require("gitsigns").nav_hunk("next") end, { desc = "Next git hunk" })
map("n", "[h", function() require("gitsigns").nav_hunk("prev") end, { desc = "Prev git hunk" })
map("n", "<leader>hs", function() require("gitsigns").stage_hunk() end, { desc = "Stage hunk" })
map("n", "<leader>hu", function() require("gitsigns").undo_stage_hunk() end, { desc = "Undo stage hunk" })

-- ----------------------------
-- Autocommands (Lua)
-- ----------------------------
-- Remove trailing whitespace on save (your old autocmd, but in Lua)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

-- ----------------------------
-- LSP-friendly defaults
-- ----------------------------
-- (Optional) basic diagnostic signs look clean with gitsigns
vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = "●" },
  float = { border = "rounded" },
  severity_sort = true,
})
