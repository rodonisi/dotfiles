return {
  {
    "nvim-flutter/flutter-tools.nvim",
    ft = "dart",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = function(opts)
      vim.keymap.set("n", "<leader>dd", "<Cmd>FlutterDebug<CR>", { desc = "Flutter Debug" })

      return {
        fvm = true,
        widget_guides = {
          enabled = true,
        },
        debugger = {
          enabled = true,
        },
        dev_log = {
          enabled = false,
        },
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        exclude = { "dart" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "dart",
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "dart-debug-adapter",
      },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "sidlatau/neotest-dart",
    },
    opts = {
      adapters = {
        ["neotest-dart"] = {
          command = "fvm flutter",
          args = { "test" },
          use_lsp = true,
        },
      },
    },
  },
}
