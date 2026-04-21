return {
  { "mbbill/undotree", cmd = "UndotreeToggle", keys = "<leader>u" },

  {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- Optional but very useful extensions from the example
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-ui-select.nvim",
  },
  cmd = "Telescope",
  keys = {
    -- Your preferred <leader>pf prefix
    { "<leader>sf", function() require("telescope.builtin").find_files({ hidden = true }) end, desc = "Find files (** recursive)" },
    { "<leader>sg", function() require("telescope.builtin").live_grep({ additional_args = { "--hidden" } }) end, desc = "Live grep" },

    -- Useful mappings from the example (kept under <leader>s for "search")
    { "<leader>sh", function() require("telescope.builtin").help_tags() end, desc = "Search Help" },
    { "<leader>sk", function() require("telescope.builtin").keymaps() end, desc = "Search Keymaps" },
    { "<leader>ss", function() require("telescope.builtin").builtin() end, desc = "Search Select Telescope" },
    { "<leader>sw", function() require("telescope.builtin").grep_string() end, desc = "Search current Word" },
    { "<leader>sd", function() require("telescope.builtin").diagnostics() end, desc = "Search Diagnostics" },
    { "<leader>sr", function() require("telescope.builtin").resume() end, desc = "Search Resume" },
    { "<leader>s.", function() require("telescope.builtin").oldfiles() end, desc = "Search Recent Files" },
    { "<leader><leader>", function() require("telescope.builtin").buffers() end, desc = "Find existing buffers" },

    -- Fuzzy search in current buffer
    { "<leader>/", function()
      require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, desc = "Fuzzily search in current buffer" },

    -- Live grep in open files only
    { "<leader>s/", function()
      require("telescope.builtin").live_grep {
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      }
    end, desc = "Live Grep in Open Files" },

    -- Search inside Neovim config files
    { "<leader>sn", function()
      require("telescope.builtin").find_files { cwd = vim.fn.stdpath("config") }
    end, desc = "Search Neovim files" },
  },
  config = function()
    require("telescope").setup({
      -- You can put defaults here
      defaults = {
        file_ignore_patterns = { "node_modules", ".git/", "build/", "DerivedData/", "__pycache__" },
        -- mappings = {
        --   i = { ["<c-enter>"] = "to_fuzzy_refine" },
        -- },
      },
      pickers = {
        -- You can customize individual pickers here if needed
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    -- Load extensions safely
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
  end,
},

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({ style = "moon" })
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "python",
          "rust",
          "swift",
          "typst",
          "json",
          "xml",
          "markdown",
          "vim",
          "vimdoc",
        },
        highlight = { enable = true },
        indent    = { enable = true },
      })
    end,
  },
  -- DadBod (DB integration)
  { "tpope/vim-dadbod", lazy = true, cmd = { "DB", "DBUI" } },

  { "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod" },
    cmd = "DBUI",
    keys = "<leader>db",
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    -- Define connections (Unix socket style - no localhost)
      vim.g.dbs = {
        dev = "postgresql:///",                     -- current user + current username as db
      -- Add more if needed:
      -- myproject = "postgresql:///myproject_db",
      -- production = "postgresql://user:pass@remotehost:5432/prod_db",  -- only for remote
      }

      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/dadbod"  -- optional: where saved queries live
      -- Your PostgreSQL connections (Unix socket + current user)
      vim.g.dbs = {
        dev = "postgresql:///" .. vim.fn.expand("$USER"),   -- current user + current username as DB
      -- Add more if needed:
      -- prod = "postgresql://user:pass@host:5432/prod_db",
    }
    end,
  },

  {
    "kristijanhusak/vim-dadbod-completion",
    ft = { "sql", "mysql", "plsql" },   -- lazy-load only for SQL files
    dependencies = { "tpope/vim-dadbod" },
  },

  -- LSP support for the languages you listed (sourcekit-lsp, rust, tinymist, lua, xml, json, python)

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
  },

  { "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
        -- This helps a bit with noiselog_levellog_level = vim.log.levels.WARN,
      })
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "jsonls",
          "rust_analyzer",
          "sqlls",          -- ← Added for SQL / PostgreSQL
      },
      -- We do NOT add sourcekit here (Mason doesn't support it)
      })
    end,
  },

  -- SourceKit-LSP for Swift (uses new Neovim 0.11+ native LSP config)
  {
    "neovim/nvim-lspconfig",  -- still needed for the server configs it ships
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Define/extend the sourcekit config
      vim.lsp.config("sourcekit", {
        cmd = { "xcrun", "sourcekit-lsp" },   -- best on macOS with Xcode
--        cmd = { "sourcekit-lsp" },   -- best on linux with no Xcode

        filetypes = { "swift", "objc", "objcpp" },

        root_dir = function(fname)
          -- Simple root detection (Package.swift is most common for Swift)
          return vim.fs.root(fname, { "Package.swift", ".git" })
        end,

        -- Optional capabilities (for better completion with nvim-cmp)
        capabilities = vim.lsp.protocol.make_client_capabilities(),

        -- You can add settings here if needed
        -- settings = { ... },
      })

      -- Actually enable the server
      vim.lsp.enable("sourcekit")
    end,
  },

  -- sqlls for SQL / PostgreSQL
  {
  "neovim/nvim-lspconfig",
  config = function()
    vim.lsp.config("sqlls", {
      cmd = { "sql-language-server", "up", "--method", "stdio" },
      filetypes = { "sql" },
      root_dir = function(fname)
        return vim.fs.root(fname, { ".git", ".sqllsrc.json" }) or vim.fn.getcwd()
      end,
      on_attach = on_attach,
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      -- Optional: add your PostgreSQL connection if you want schema awareness
      -- settings = {
      --   sql = {
      --     connections = {
      --       {
      --         driver = "postgresql",
      --         dataSourceName = "host=/var/run/postgresql user=" .. vim.fn.expand("$USER") .. " dbname=yourdb sslmode=disable",
      --       },
      --     },
      --   },
      -- },
    })
    vim.lsp.enable("sqlls")
  end,
},

  -- Basic completion (required for a usable LSP experience)
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
	    "hrsh7th/cmp-nvim-lsp",
	    "hrsh7th/cmp-buffer",
	    "hrsh7th/cmp-path",
      "kristijanhusak/vim-dadbod-completion",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
          { name = "vim-dadbod-completion" },
        },
      })
      vim.api.nvim_create_autocmd("FileType", {
      pattern = { "sql", "mysql", "plsql" },
      callback = function()
        cmp.setup.buffer({
          sources = cmp.config.sources({
            { name = "vim-dadbod-completion" },
            { name = "buffer" },
          }),
        })
      end,
    })
    end,
  },

  -- Optional: LSP progress UI
  { "j-hui/fidget.nvim", config = function() require("fidget").setup({}) end },
}
