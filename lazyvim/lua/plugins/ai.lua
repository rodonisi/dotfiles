return {
  {
    "zbirenbaum/copilot.lua",
    dependencies = {
      "copilotlsp-nvim/copilot-lsp",
    },
    opts = {
      nes = { enable = true },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      "fang2hou/blink-copilot",
    },
    opts = {
      sources = {
        default = { "copilot" },
        providers = {
          copilot = {
            opts = {
              max_completions = 3,
            },
          },
        },
      },
      fuzzy = {
        sorts = {
          "exact",
          -- defaults
          "score",
          "sort_text",
        },
      },
    },
  },
}
