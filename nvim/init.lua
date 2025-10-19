-- INFO: Ross Kostadinov NVIM Configuration

--
-- 1) Core Options --------------------------------------------------------
--
vim.g.mapleader = " "       -- Set <space> as the leader key
vim.g.maplocalleader = " "  -- See `:help mapleader`
vim.g.have_nerd_font = true -- Set to true if you have a Nerd Font installed and selected in the terminal

-- UI
vim.opt.number = true         -- Absolute line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.numberwidth = 4       -- Number column width
vim.opt.termguicolors = true  -- 24-bit colors
vim.opt.cursorline = true     -- Highlight current line
vim.opt.signcolumn = "yes"    -- Stable sign column
vim.opt.wrap = false          -- Don't wrap long lines
vim.opt.scrolloff = 10        -- Keep context around cursor
vim.opt.showmode = false      -- Hide -- INSERT -- (statusline will show)
vim.opt.showtabline = 2       -- Show tabs
vim.opt.mouse = "a"           -- Mouse support
vim.o.confirm = true          -- Confirm before exiting
vim.schedule(function()       -- Sync clipboard between OS and Neovim.
  vim.o.clipboard = "unnamedplus"
end)

-- Editing
vim.opt.expandtab = true   -- Tabs -> spaces
vim.opt.tabstop = 2        -- Visual width of tabs
vim.opt.softtabstop = 2    -- <Tab> in insert mode
vim.opt.shiftwidth = 2     -- Indent width
vim.opt.smartindent = true -- Smart indent

-- Search
vim.opt.incsearch = true  -- Incremental search
vim.opt.hlsearch = false  -- Don't persist highlights
vim.opt.ignorecase = true -- Case-insensitive by default
vim.opt.smartcase = true  -- ...unless query has capitals

-- Windows / Buffers
vim.opt.splitbelow = true -- New horizontal splits go below
vim.opt.splitright = true -- New vertical splits go right
vim.opt.hidden = true     -- Switch buffers without saving

-- Undo / Backups
vim.opt.swapfile = false -- No swap files
vim.opt.backup = false   -- No backups
vim.opt.undofile = true  -- Persistent undo

-- Perf
vim.opt.updatetime = 250 -- Faster UI updates
vim.o.timeoutlen = 300   -- Decrease mapped sequence wait time

--
-- 2) Keymaps (with comments) ----------------------------------------
--

-- Quick exit from insert/visual using "jj" and "kj"
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit Insert mode" })
vim.keymap.set("v", "kj", "<Esc>", { desc = "Exit Visual mode" })

-- Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- File Explorer: toggle nvim-tree
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Telescope pickers (replacing fzf.vim usage)
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })

-- Increment / Decrement numbers with leader
vim.keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
vim.keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Buffer Management
vim.keymap.set("n", "<leader>bc", "<cmd>enew<CR>", { desc = "New empty buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>bx", "<cmd>bwipeout<CR>", { desc = "Wipe buffer" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bl", "<cmd>ls<CR>", { desc = "List buffers" })
vim.keymap.set("n", "<leader>bb", "<cmd>BufferLinePick<CR>", { desc = "Pick buffer" })
vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", { desc = "Close other buffers" })

-- Move between buffers (Shift + h/l)
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })

-- Window / Pane Management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equalize window sizes" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current window" })

-- Window / Pane Navigation with hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left pane" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower pane" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper pane" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right pane" })

--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Center screen after motions/search
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
-- The lines bellow are currently not needed, because of Neoscroll plugin
-- vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half-page down (centered)" })
-- vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half-page up (centered)" })

-- Resize windows with Ctrl+Arrows
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- LazyGit shortcuts (floating window)
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "LazyGit (float)" })
vim.keymap.set("n", "<leader>gF", "<cmd>LazyGitCurrentFile<CR>", { desc = "LazyGit current file" })

-- Which-key helpers in a window (Telescope-like UX)
vim.keymap.set("n", "<leader>wk", function() require("which-key").show({ keys = "<leader>", loop = true }) end,
  { desc = "Which-key: Leader menu" })

-- Other
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear highlights on search" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" }) -- Diagnostic keymaps
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })


--
-- 3) Autocommands --------------------------------------------------------
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

-- Highlight when yanking (copying) text. Try it with `yap` in normal mode
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_set_hl(0, 'BufferLineFill', { bg = "#1a1b26" })

--
-- 4) Plugin Manager: Lazy
--

-- Install Lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)


--
-- 5) Plugins
--
require("lazy").setup({

  -- THEME -----------------------------------------------------------------
  {
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    "folke/tokyonight.nvim",
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("tokyonight").setup({
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      })

      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  -- Mini Icons
  { "echasnovski/mini.icons", version = "*", opts = {} },

  -- STATUSLINE (with powerline arrows) -------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "tokyonight",
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

  -- Dressing
  {
    "stevearc/dressing.nvim",
    opts = {},
  },


  -- FILE EXPLORER --------------------------------------------------------
  -- Buffer Line
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        mode = "buffers",         -- show buffers as tabs
        diagnostics = "nvim_lsp", -- show LSP diagnostics on tabs
        always_show_bufferline = true,
        offsets = {
          { filetype = "NvimTree", text = "File Explorer", highlight = "Directory", separator = true },
        },
        show_close_icon = false,
        separator_style = "thin"
      },
    },
  },

  -- Nvim tree - Float Window
  -- {
  --   "kyazdani42/nvim-tree.lua",
  --   dependencies = {
  --     "kyazdani42/nvim-web-devicons",
  --   },
  --   lazy = false,
  --   keys = {
  --     { "<leader>e", "<cmd>NvimTreeFindFile<cr>", desc = "Find file in filetree" },
  --     { "<C-n>",     "<cmd>NvimTreeToggle<cr>",   desc = "Find file in filetree" },
  --   },
  --   opts = {
  --     filters = {
  --       custom = { ".git", "node_modules", ".vscode" },
  --       dotfiles = true,
  --     },
  --     git = {},
  --     view = {
  --       adaptive_size = true,
  --       float = {
  --         enable = true,
  --       },
  --     },
  --   },
  -- },

  -- Nvim Tree - Split window
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
      win = { border = "rounded" },
      layout = { spacing = 6, align = "left" },
      spec = {
        -- Group labels for your leader menus and common prefixes
        { "<leader>f", group = "File/Find", mode = { "n", "v" } },
        { "<leader>g", group = "Git",       mode = { "n", "v" } },
        { "<leader>b", group = "Buffers",   mode = { "n", "v" } },
        {
          "<leader>w",
          group = "Windows",
          proxy = "<c-w>",
          mode = { "n" },
          expand = function() return require("which-key.extras").expand.win() end
        },
        { "<leader>t", group = "Tabs",                mode = { "n" } },
        { "<leader>s", group = "Splits",              mode = { "n" } },
        { "<leader>u", group = "UI",                  mode = { "n" } },
        { "<leader>x", group = "Diagnostics",         mode = { "n" } },
        { "<leader>e", group = "Explorer",            mode = { "n" } },
        { "g",         group = "Go To",               mode = { "n", "v" } },
        { "z",         group = "Fold",                mode = { "n" } },
        { "[",         group = "Prev",                mode = { "n" } },
        { "]",         group = "Next",                mode = { "n" } },
        { "gx",        desc = "Open with system app", mode = { "n" } },
      },
    },
    keys = {
      { "<leader>?",    function() require("which-key").show({ global = false }) end,              desc = "Show buffer-local keymaps" },
      { "<c-w><space>", function() require("which-key").show({ keys = "<c-w>", loop = true }) end, desc = "Window keymap helper" },
    },
  },

  -- GIT ----------------------------------------------------------------
  { -- Git Signs
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },

  { -- LazyGit (floating window like Telescope)
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitCurrentFile", "LazyGitConfig" },
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_floating_window_scaling_factor = 0.95
      vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
      vim.g.lazygit_use_neovim_remote = 1
    end,
  },

  -- FUZZY FINDING (Files, LSP, etc) --------------------------------------------------

  { -- Telescope
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",

        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-tree/nvim-web-devicons",            enabled = vim.g.have_nerd_font },
    },

    -- [[ Configure Telescope ]]
    config = function()
      -- See `:help telescope` and `:help telescope.setup()`
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      -- Enable Telescope extensions if they are installed
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      -- See `:help telescope.builtin`
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set("n", "<leader>/", function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set("n", "<leader>s/", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end, { desc = "[S]earch [/] in Open Files" })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set("n", "<leader>sn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[S]earch [N]eovim files" })
    end,
  },

  -- LSP Plugins ------------------------------------------------------------------------
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- Main LSP Configuration -------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim",                     opts = {} },
      { "mason-org/mason-lspconfig.nvim" },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      { "j-hui/fidget.nvim",                        opts = {} }, -- Useful status updates for LSP.
      { "saghen/blink.cmp", }                                    -- Allows extra capabilities provided by blink.cmp
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("grn", vim.lsp.buf.rename, "[R]e[n]ame")                                                    -- Rename the variable under your cursor.
          map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })                       -- Execute a code action
          map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")                  -- Find references for that word
          map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")         -- Jump to the implementation of that word
          map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")                 -- Jump to the definition
          map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
          map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")           -- Fuzzy find all the symbols in your current document.
          map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols") -- Fuzzy find all the symbols in your current workspace.
          map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")       -- Jump to the type of that word

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has("nvim-0.11") == 1 then
              return client:supports_method(method, bufnr)
            else
              ---@diagnostic disable-next-line: param-type-mismatch
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if
              client
              and client_supports_method(
                client,
                vim.lsp.protocol.Methods.textDocument_documentHighlight,
                event.buf
              )
          then
            local highlight_augroup =
                vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if
              client
              and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
          then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      -- Diagnostic Config ---
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        } or {},
        virtual_text = {
          source = "if_many",
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      })

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Enable the following language servers
      local servers = {
        clangd = {},
        gopls = {},
        pyright = {},
        rust_analyzer = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              diagnostics = { disable = { "missing-fields" } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },

  -- AUTOFORMAT -------------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = "fallback",
          }
        end
      end,
      formatters_by_ft = {
        lua = {},
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },

  -- AUTOCOMPLETION ---------------------------------------------------------------------
  {
    "saghen/blink.cmp",
    event = "VimEnter",
    version = "1.*",
    dependencies = {
      -- Snippet Engine
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
        opts = {},
      },
      "folke/lazydev.nvim",
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = "default",

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { "lsp", "path", "snippets", "lazydev" },
        providers = {
          lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },

      snippets = { preset = "luasnip" },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = "lua" },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },


  -- Highlight todo, notes, etc in comments ---------------------------------------------
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = false,
      keywords = {
        FIX = {
          icon = " ", -- icon used for the sign, and in search results
          color = "error", -- can be a hex color, or a named color (see below)
          alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
          -- signs = false, -- configure signs for some keywords individually
        },
        TODO = {
          icon = " ",
          color = "info",
          alt = { "SECTION" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
          TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
      },
    },
  },

  { -- Highlight, edit, and navigate code -----------------------------------------------
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs", -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "query",
        "vim",
        "vimdoc",
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { "ruby" },
      },
      indent = { enable = true, disable = { "ruby" } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  -- NeoScroll (Smooth scroll)
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      local neoscroll = require("neoscroll")

      neoscroll.setup({
        easing_function = "quadratic",
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
      })

      local dur_half = 250
      local dur_full = 450

      local function center_after(ms)
        vim.defer_fn(function()
          -- center without affecting registers/mappings
          vim.cmd("normal! zz")
        end, ms)
      end

      -- Half-page with center
      vim.keymap.set({ "n", "v" }, "<C-d>", function()
        neoscroll.ctrl_d({ duration = dur_half })
        center_after(dur_half)
      end, { silent = true })

      vim.keymap.set({ "n", "v" }, "<C-u>", function()
        neoscroll.ctrl_u({ duration = dur_half })
        center_after(dur_half)
      end, { silent = true })

      -- Full-page with center (optional)
      vim.keymap.set({ "n", "v" }, "<C-f>", function()
        neoscroll.ctrl_f({ duration = dur_full })
        center_after(dur_full)
      end, { silent = true })

      vim.keymap.set({ "n", "v" }, "<C-b>", function()
        neoscroll.ctrl_b({ duration = dur_full })
        center_after(dur_full)
      end, { silent = true })

      -- Gentle line scrolls (no centering)
      vim.keymap.set({ "n", "v" }, "<C-e>", function()
        neoscroll.scroll(0.10, { move_cursor = false, duration = 100 })
      end, { silent = true })

      vim.keymap.set({ "n", "v" }, "<C-y>", function()
        neoscroll.scroll(-0.10, { move_cursor = false, duration = 100 })
      end, { silent = true })
    end,
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      -- explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {
          -- wo = { wrap = true } -- Wrap notifications
        }
      }
    },
    keys = {
      -- Top Pickers & Explorer
      { "<leader><space>", function() Snacks.picker.smart() end,                                   desc = "Smart Find Files" },
      { "<leader>,",       function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
      { "<leader>/",       function() Snacks.picker.grep() end,                                    desc = "Grep" },
      { "<leader>:",       function() Snacks.picker.command_history() end,                         desc = "Command History" },
      { "<leader>n",       function() Snacks.picker.notifications() end,                           desc = "Notification History" },
      -- { "<leader>e",       function() Snacks.explorer() end,                                       desc = "File Explorer" },
      -- find
      { "<leader>fb",      function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
      { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>ff",      function() Snacks.picker.files() end,                                   desc = "Find Files" },
      { "<leader>fg",      function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
      { "<leader>fp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
      { "<leader>fr",      function() Snacks.picker.recent() end,                                  desc = "Recent" },
      -- git
      { "<leader>gb",      function() Snacks.picker.git_branches() end,                            desc = "Git Branches" },
      { "<leader>gl",      function() Snacks.picker.git_log() end,                                 desc = "Git Log" },
      { "<leader>gL",      function() Snacks.picker.git_log_line() end,                            desc = "Git Log Line" },
      { "<leader>gs",      function() Snacks.picker.git_status() end,                              desc = "Git Status" },
      { "<leader>gS",      function() Snacks.picker.git_stash() end,                               desc = "Git Stash" },
      { "<leader>gd",      function() Snacks.picker.git_diff() end,                                desc = "Git Diff (Hunks)" },
      { "<leader>gf",      function() Snacks.picker.git_log_file() end,                            desc = "Git Log File" },
      -- Grep
      { "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
      { "<leader>sB",      function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
      { "<leader>sg",      function() Snacks.picker.grep() end,                                    desc = "Grep" },
      { "<leader>sw",      function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      { '<leader>s"',      function() Snacks.picker.registers() end,                               desc = "Registers" },
      { '<leader>s/',      function() Snacks.picker.search_history() end,                          desc = "Search History" },
      { "<leader>sa",      function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
      { "<leader>sb",      function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },
      { "<leader>sc",      function() Snacks.picker.command_history() end,                         desc = "Command History" },
      { "<leader>sC",      function() Snacks.picker.commands() end,                                desc = "Commands" },
      { "<leader>sd",      function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
      { "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end,                      desc = "Buffer Diagnostics" },
      { "<leader>sh",      function() Snacks.picker.help() end,                                    desc = "Help Pages" },
      { "<leader>sH",      function() Snacks.picker.highlights() end,                              desc = "Highlights" },
      { "<leader>si",      function() Snacks.picker.icons() end,                                   desc = "Icons" },
      { "<leader>sj",      function() Snacks.picker.jumps() end,                                   desc = "Jumps" },
      { "<leader>sk",      function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
      { "<leader>sl",      function() Snacks.picker.loclist() end,                                 desc = "Location List" },
      { "<leader>sm",      function() Snacks.picker.marks() end,                                   desc = "Marks" },
      { "<leader>sM",      function() Snacks.picker.man() end,                                     desc = "Man Pages" },
      { "<leader>sp",      function() Snacks.picker.lazy() end,                                    desc = "Search for Plugin Spec" },
      { "<leader>sq",      function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },
      { "<leader>sR",      function() Snacks.picker.resume() end,                                  desc = "Resume" },
      { "<leader>su",      function() Snacks.picker.undo() end,                                    desc = "Undo History" },
      { "<leader>uC",      function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },
      -- LSP
      { "gd",              function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
      { "gD",              function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
      { "gr",              function() Snacks.picker.lsp_references() end,                          nowait = true,                     desc = "References" },
      { "gI",              function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
      { "gy",              function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
      { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
      { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },
      -- Other
      { "<leader>z",       function() Snacks.zen() end,                                            desc = "Toggle Zen Mode" },
      { "<leader>Z",       function() Snacks.zen.zoom() end,                                       desc = "Toggle Zoom" },
      { "<leader>.",       function() Snacks.scratch() end,                                        desc = "Toggle Scratch Buffer" },
      { "<leader>S",       function() Snacks.scratch.select() end,                                 desc = "Select Scratch Buffer" },
      { "<leader>n",       function() Snacks.notifier.show_history() end,                          desc = "Notification History" },
      { "<leader>bd",      function() Snacks.bufdelete() end,                                      desc = "Delete Buffer" },
      { "<leader>cR",      function() Snacks.rename.rename_file() end,                             desc = "Rename File" },
      { "<leader>gB",      function() Snacks.gitbrowse() end,                                      desc = "Git Browse",               mode = { "n", "v" } },
      { "<leader>gg",      function() Snacks.lazygit() end,                                        desc = "Lazygit" },
      { "<leader>un",      function() Snacks.notifier.hide() end,                                  desc = "Dismiss All Notifications" },
      { "<c-/>",           function() Snacks.terminal() end,                                       desc = "Toggle Terminal" },
      { "<c-_>",           function() Snacks.terminal() end,                                       desc = "which_key_ignore" },
      { "]]",              function() Snacks.words.jump(vim.v.count1) end,                         desc = "Next Reference",           mode = { "n", "t" } },
      { "[[",              function() Snacks.words.jump(-vim.v.count1) end,                        desc = "Prev Reference",           mode = { "n", "t" } },
      {
        "<leader>N",
        desc = "Neovim News",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      }
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end

          -- Override print to use snacks for `:=` command
          if vim.fn.has("nvim-0.11") == 1 then
            vim._print = function(_, ...)
              dd(...)
            end
          else
            vim.print = _G.dd
          end

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
            "<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },
  -- Collection of various small independent plugins/modules -----------------------------
  {
    "echasnovski/mini.nvim",
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require("mini.ai").setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require("mini.surround").setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require("mini.statusline")
      -- set use_icons to true if you have a Nerd Font
      statusline.setup({ use_icons = vim.g.have_nerd_font })

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return "%2l:%-2v"
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },


  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  -- require("kickstart.plugins.gitsigns"), -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    border = "rounded",
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
