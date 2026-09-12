local p = require("oxblood.palette")

return {
  -- The colorscheme lives in colors/, not in a plugin. This stub just makes
  -- lazy load it first, before anything else draws.
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = { color_icons = true },
  },

  ---------------------------------------------------------------- statusline --
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      -- Flat separators only. No powerline wedges, no rounded caps.
      local theme = {
        normal = {
          a = { fg = p.bg, bg = p.blue_br, gui = "bold" },
          b = { fg = p.fg, bg = p.bg_alt },
          c = { fg = p.fg_dim, bg = "NONE" },
        },
        insert = { a = { fg = p.bg, bg = p.green_br, gui = "bold" } },
        visual = { a = { fg = p.bg, bg = p.yellow_br, gui = "bold" } },
        replace = { a = { fg = p.bg, bg = p.red_br, gui = "bold" } },
        command = { a = { fg = p.bg, bg = p.magenta_br, gui = "bold" } },
        terminal = { a = { fg = p.bg, bg = p.cyan_br, gui = "bold" } },
        inactive = {
          a = { fg = p.grey, bg = "NONE" },
          b = { fg = p.grey, bg = "NONE" },
          c = { fg = p.grey, bg = "NONE" },
        },
      }

      return {
        options = {
          theme = theme,
          component_separators = "",
          section_separators = "",
          globalstatus = true,
          disabled_filetypes = { statusline = { "neo-tree", "lazy", "mason" } },
        },
        sections = {
          lualine_a = { { "mode", fmt = function(s) return " " .. s:sub(1, 1) .. s:sub(2):lower() .. " " end } },
          lualine_b = {
            { "branch", icon = "" },
            {
              "diff",
              symbols = { added = "+", modified = "~", removed = "-" },
              diff_color = {
                added = { fg = p.green },
                modified = { fg = p.blue_br },
                removed = { fg = p.red_br },
              },
            },
          },
          lualine_c = {
            { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = "[no name]" } },
          },
          lualine_x = {
            {
              "diagnostics",
              symbols = { error = "E", warn = "W", info = "I", hint = "H" },
              diagnostics_color = {
                error = { fg = p.red_br },
                warn = { fg = p.yellow },
                info = { fg = p.blue_br },
                hint = { fg = p.cyan },
              },
            },
            -- Which LSPs are actually attached to this buffer.
            {
              function()
                local names = {}
                for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
                  names[#names + 1] = client.name
                end
                return #names > 0 and table.concat(names, " ") or ""
              end,
              color = { fg = p.grey },
            },
          },
          lualine_y = {
            { "encoding", color = { fg = p.grey } },
            { "fileformat", symbols = { unix = "unix", dos = "dos", mac = "mac" }, color = { fg = p.grey } },
          },
          lualine_z = { { "location", padding = { left = 1, right = 1 } }, { "progress" } },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "lazy", "mason", "quickfix", "man" },
      }
    end,
  },

  ---------------------------------------------------------------- bufferline --
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete unpinned buffers" },
      { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Delete buffers to the right" },
      { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Delete buffers to the left" },
    },
    opts = {
      options = {
        mode = "buffers",
        numbers = "none",
        close_command = "bdelete! %d",
        indicator = { style = "underline" },
        -- Thin vertical rules: squared off, no slants or wedges.
        separator_style = { "│", "│" },
        modified_icon = "●",
        buffer_close_icon = "×",
        close_icon = "×",
        left_trunc_marker = "‹",
        right_trunc_marker = "›",
        max_name_length = 22,
        tab_size = 18,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local s = {}
          if diag.error then s[#s + 1] = "E" .. diag.error end
          if diag.warning then s[#s + 1] = "W" .. diag.warning end
          return #s > 0 and (" " .. table.concat(s, " ")) or ""
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "FILES",
            text_align = "left",
            separator = true,
            highlight = "NeoTreeRootName",
          },
        },
        show_buffer_close_icons = true,
        show_close_icon = false,
        always_show_bufferline = false,
      },
    },
  },

  ------------------------------------------------------------------ which-key --
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 350,
      win = { border = "single", padding = { 0, 1 } },
      icons = { mappings = false, separator = "→" },
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>o", group = "options" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "toggle" },
        { "<leader>x", group = "diagnostics" },
        { "[", group = "previous" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "z", group = "fold" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
    },
  },

  ------------------------------------------------------------- indent guides --
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = { char = "│", tab_char = "│" },
      scope = { enabled = true, show_start = false, show_end = false },
      exclude = {
        filetypes = {
          "help", "lazy", "mason", "neo-tree", "checkhealth", "man",
          "gitcommit", "dashboard", "terminal", "markdown", "text",
        },
      },
    },
  },
}
