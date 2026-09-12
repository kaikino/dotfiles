return {
  --------------------------------------------------------------- server mgmt --
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "single",
        icons = { package_installed = "●", package_pending = "◌", package_uninstalled = "○" },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      ------------------------------------------------------------ diagnostics --
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,          -- don't churn while you type
        severity_sort = true,
        virtual_text = {
          spacing = 2,
          prefix = "▪",
          source = "if_many",
        },
        float = {
          border = "single",
          source = "if_many",
          header = "",
          prefix = "",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN] = "W",
            [vim.diagnostic.severity.INFO] = "I",
            [vim.diagnostic.severity.HINT] = "H",
          },
        },
      })

      ----------------------------------------------------------- on LspAttach --
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("oxblood_lsp_attach", { clear = true }),
        callback = function(ev)
          local buf = ev.buf
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local map = function(keys, fn, desc, mode)
            vim.keymap.set(mode or "n", keys, fn, { buffer = buf, silent = true, desc = "LSP: " .. desc })
          end

          map("gd", "<cmd>Telescope lsp_definitions<cr>", "Go to definition")
          map("gr", "<cmd>Telescope lsp_references<cr>", "References")
          map("gI", "<cmd>Telescope lsp_implementations<cr>", "Implementations")
          map("gy", "<cmd>Telescope lsp_type_definitions<cr>", "Type definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("K", function() vim.lsp.buf.hover({ border = "single" }) end, "Hover docs")
          map("gK", function() vim.lsp.buf.signature_help({ border = "single" }) end, "Signature help")
          map("<C-k>", function() vim.lsp.buf.signature_help({ border = "single" }) end, "Signature help", "i")
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
          map("<leader>cs", "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols")
          map("<leader>cS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace symbols")

          -- Inlay hints on by default where the server offers them.
          if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = buf })
          end

          -- Underline the symbol under the cursor after a short pause.
          if client and client:supports_method("textDocument/documentHighlight") then
            local group = vim.api.nvim_create_augroup("oxblood_lsp_highlight_" .. buf, { clear = true })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              group = group, buffer = buf, callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              group = group, buffer = buf, callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      ------------------------------------------------------- server settings --
      -- Neovim 0.11+ merges these into the defaults shipped by nvim-lspconfig.
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { checkThirdParty = false },
            diagnostics = { globals = { "vim" } },
            hint = { enable = true, arrayIndex = "Disable" },
            format = { enable = false },   -- stylua handles this
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("vtsls", {
        settings = {
          typescript = {
            inlayHints = {
              parameterNames = { enabled = "literals" },
              variableTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
            },
          },
        },
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            staticcheck = true,
          },
        },
      })

      -- Python is split in two: pyright for types and navigation, ruff for
      -- lint and format. basedpyright would be the better single choice, but
      -- it installs from pypi and this machine's only python3 is 3.9.
      vim.lsp.config("pyright", {
        settings = {
          pyright = { disableOrganizeImports = true },   -- ruff does this
          python = {
            analysis = {
              typeCheckingMode = "standard",
              autoImportCompletions = true,
              -- Let ruff own the lint diagnostics so they aren't doubled up.
              ignore = { "*" },
            },
          },
        },
      })

      vim.lsp.config("ruff", {
        on_attach = function(client)
          client.server_capabilities.hoverProvider = false   -- pyright's is better
        end,
      })

      vim.lsp.config("yamlls", {
        settings = { yaml = { keyOrdering = false } },
      })

      ------------------------------------------------------ install + enable --
      -- Servers, by their lspconfig name. mason-lspconfig enables every one it
      -- finds installed; the table below only adds our settings on top.
      local servers = {
        lua_ls = "lua-language-server",
        vtsls = "vtsls",                      -- typescript / javascript
        pyright = "pyright",                  -- python types
        ruff = "ruff",                        -- python lint + format
        gopls = "gopls",
        rust_analyzer = "rust-analyzer",
        bashls = "bash-language-server",      -- sh / zsh
        jsonls = "json-lsp",
        yamlls = "yaml-language-server",
        html = "html-lsp",
        cssls = "css-lsp",
        taplo = "taplo",                      -- toml
        marksman = "marksman",                -- markdown
      }

      -- Formatters and linters conform.nvim reaches for.
      local tools = { "stylua", "prettierd", "shfmt", "ruff", "gofumpt", "goimports" }

      -- stylua ships an lspconfig entry ("stylua --lsp"). We format through
      -- conform instead, so keep it from starting as a second server.
      require("mason-lspconfig").setup({
        automatic_enable = { exclude = { "stylua" } },
      })

      -- Everything goes through mason-tool-installer under its mason package
      -- name, so there is exactly one list to keep in step.
      local packages = vim.tbl_values(servers)
      vim.list_extend(packages, tools)
      require("mason-tool-installer").setup({
        ensure_installed = packages,
        run_on_start = false,       -- fires on VimEnter, which we load after
        auto_update = false,
      })

      -- This plugin loads on BufReadPre, often after VimEnter has already
      -- passed, so its own start hook never runs. Kick it off once ourselves,
      -- and only when something is actually missing -- otherwise every launch
      -- pays for a registry refresh it does not need.
      vim.defer_fn(function()
        local ok, registry = pcall(require, "mason-registry")
        if not ok then return end
        for _, pkg in ipairs(packages) do
          if not registry.is_installed(pkg) then
            vim.cmd("MasonToolsInstall")
            return
          end
        end
      end, 1500)
    end,
  },

  ----------------------------------------------------------------- formatting --
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        mode = { "n", "x" },
        desc = "Format buffer",
      },
      {
        "<leader>uf",
        function()
          vim.g.oxblood_autoformat = not (vim.g.oxblood_autoformat ~= false)
          vim.notify("format on save " .. (vim.g.oxblood_autoformat and "on" or "off"))
        end,
        desc = "Toggle format on save",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format", "ruff_organize_imports" },
        go = { "goimports", "gofumpt" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        javascript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        json = { "prettierd" },
        jsonc = { "prettierd" },
        yaml = { "prettierd" },
        html = { "prettierd" },
        css = { "prettierd" },
        scss = { "prettierd" },
        markdown = { "prettierd" },
      },
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = function(bufnr)
        if vim.g.oxblood_autoformat == false then return end
        -- Skip huge files and anything under a vendored path.
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name:match("/node_modules/") or name:match("/vendor/") then return end
        return { timeout_ms = 2000, lsp_format = "fallback" }
      end,
    },
  },

  ----------------------------------------------------------------- completion --
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = {
        preset = "default",             -- <C-n>/<C-p> to move, <C-y> to accept
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-f>"] = { "scroll_documentation_up", "fallback" },
      },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = {
          border = "single",
          draw = { treesitter = { "lsp" } },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = "single" },
        },
        ghost_text = { enabled = false },
      },
      signature = { enabled = true, window = { border = "single" } },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      cmdline = {
        keymap = { preset = "inherit" },
        completion = { menu = { auto_show = true } },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
