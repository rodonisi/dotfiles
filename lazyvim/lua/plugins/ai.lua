return {
  -- {
  --   "zbirenbaum/copilot.lua",
  --   dependencies = {
  --     "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
  --   },
  --   opts = {}
  -- },
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   dependencies = {
  --     "zbirenbaum/copilot.lua",
  --   },
  --   opts = {}
  -- },
  -- {
  --   "saghen/blink.cmp",
  --   optional = true,
  --   dependencies = { "fang2hou/blink-copilot" },
  --   opts = {
  --     sources = {
  --       default = { "copilot" },
  --       providers = {
  --         copilot = {
  --           name = "copilot",
  --           module = "blink-copilot",
  --           score_offset = 100,
  --           async = true,
  --         },
  --       },
  --     },
  --   },
  -- }
  {
    "saghen/blink.cmp",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {

      keymap = {
        ["<Tab>"] = {
          "snippet_forward",
          function() -- sidekick next edit suggestion
            return require("sidekick").nes_jump_or_apply()
          end,
          function() -- if you are using Neovim's native inline completions
            return vim.lsp.inline_completion.get()
          end,
          "fallback",
        },
      },
    },
  }
}
