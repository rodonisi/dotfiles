return {
  "Isrothy/neominimap.nvim",
  lazy = false, -- NOTE: NO NEED to Lazy load
  dependencies = { "nvim-treesitter/nvim-treesitter", "lewis6991/gitsigns.nvim" },
  keys = {
    { "<leader>um", "<cmd>Neominimap Toggle<cr>", desc = "Toggle Minimap" },
  },
  init = function()
    vim.g.neominimap = {
      auto_enable = true,
      layout = "split",
      split = {
        minimap_width = 16,
        fix_width = true,
      },
      x_multiplier = 3,
      y_multiplier = 1,
      search = {
        enabled = false,
      },
    }
  end,
}
