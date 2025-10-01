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
        debugger = {
          enabled = true,
        },
        dev_log = {
          enabled = false,
        },
        lsp = {
          color = {
            enabled = true,
          },
        },
      }
    end,
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
          use_lsp = true,
        },
      },
    },
  },
}
