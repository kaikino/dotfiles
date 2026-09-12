return {
  ------------------------------------------------------------------ telescope --
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make", enabled = vim.fn.executable("make") == 1 },
    },
    keys = {
      { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Git files" },
      { "<leader>fc", function() require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") }) end, desc = "Config files" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep in project" },
      { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Grep word under cursor" },
      { "<leader>sw", "<cmd>Telescope grep_string<cr>", mode = "x", desc = "Grep selection" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in buffer" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help pages" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Marks" },
      { "<leader>sr", "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume last search" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
      { "<leader>gB", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix = "  ",
          selection_caret = "▌ ",
          entry_prefix = "  ",
          multi_icon = "+ ",
          borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
          path_display = { "filename_first" },
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
            width = 0.9,
            height = 0.85,
          },
          file_ignore_patterns = {
            "^%.git/", "node_modules/", "%.lock$", "target/", "dist/", "build/",
            "%.png$", "%.jpg$", "%.jpeg$", "%.gif$", "%.pdf$", "%.zip$",
          },
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case", "--hidden",
            "--glob", "!**/.git/*",
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["<C-u>"] = false,           -- let C-u clear the prompt line
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<C-f>"] = actions.preview_scrolling_up,
              ["<Esc>"] = actions.close,   -- one Esc, not two
            },
            n = { ["q"] = actions.close },
          },
        },
        pickers = {
          find_files = { hidden = true, find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" } },
          buffers = {
            sort_mru = true,
            ignore_current_buffer = true,
            mappings = { i = { ["<C-x>"] = actions.delete_buffer }, n = { ["dd"] = actions.delete_buffer } },
          },
        },
        extensions = {
          fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
    end,
  },

  ------------------------------------------------------------------ file tree --
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle reveal left<cr>", desc = "File tree" },
      { "<leader>E", "<cmd>Neotree reveal left<cr>", desc = "Reveal file in tree" },
      { "<leader>fG", "<cmd>Neotree float git_status<cr>", desc = "Git status tree" },
    },
    opts = {
      close_if_last_window = true,
      popup_border_style = "single",
      enable_git_status = true,
      enable_diagnostics = true,
      sort_case_insensitive = true,
      default_component_configs = {
        indent = {
          indent_size = 2,
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          expander_collapsed = "›",
          expander_expanded = "⌄",
        },
        modified = { symbol = "●" },
        git_status = {
          symbols = {
            added = "+", modified = "~", deleted = "-", renamed = "→",
            untracked = "?", ignored = "◌", unstaged = "󰄱", staged = "✓", conflict = "!",
          },
        },
      },
      window = {
        width = 32,
        mappings = {
          ["<space>"] = "none",      -- keep leader usable inside the tree
          ["l"] = "open",
          ["h"] = "close_node",
          ["<cr>"] = "open",
          ["s"] = "open_vsplit",
          ["S"] = "open_split",
          ["t"] = "open_tabnew",
          ["Y"] = function(state)
            local path = state.tree:get_node().path
            vim.fn.setreg("+", path)
            vim.notify("copied: " .. path)
          end,
          ["O"] = function(state)
            vim.fn.jobstart({ "open", state.tree:get_node().path }, { detach = true })
          end,
        },
      },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = { ".DS_Store", "node_modules", ".git" },
        },
      },
      event_handlers = {
        -- Close the tree after opening a file: it's a picker, not a panel.
        {
          event = "file_opened",
          handler = function() require("neo-tree.command").execute({ action = "close" }) end,
        },
      },
    },
  },

  ---------------------------------------------------------------- mini basics --
  {
    "echasnovski/mini.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("mini.pairs").setup()                     -- auto-close brackets
      require("mini.surround").setup({                  -- sa/sd/sr to add/delete/replace
        mappings = {
          add = "sa", delete = "sd", replace = "sr",
          find = "sf", find_left = "sF", highlight = "sh",
          update_n_lines = "sn",
        },
      })
      require("mini.ai").setup({ n_lines = 500 })       -- smarter ci( ca" va} etc.
      require("mini.move").setup({                      -- Alt-hjkl to shift text
        mappings = {
          left = "<M-h>", right = "<M-l>", down = "<M-j>", up = "<M-k>",
          line_left = "<M-h>", line_right = "<M-l>",
          line_down = "<M-j>", line_up = "<M-k>",
        },
      })
    end,
  },

  ------------------------------------------------------------ todo highlights --
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo comments" },
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo" },
    },
    opts = { signs = false },
  },
}
