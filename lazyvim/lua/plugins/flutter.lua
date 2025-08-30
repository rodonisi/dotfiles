return {
  {
    "nvim-flutter/flutter-tools.nvim",
    ft = "dart",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("flutter-tools").setup({
        fvm = true,
        debugger = {
          enabled = true,
        },
        lsp = {
          color = {
            enabled = true,
          },
        },
      })
    end,
  },
}
