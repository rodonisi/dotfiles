return {
  {
    "nvim-flutter/flutter-tools.nvim",
    ft = "dart",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
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
      lsp = {
        settings = {
          inlayHints = false,
        },
      },
    },
  },
}
