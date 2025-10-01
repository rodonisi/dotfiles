return {
  "Isrothy/neominimap.nvim",
  lazy = false, -- NOTE: NO NEED to Lazy load
  dependencies = { "nvim-treesitter/nvim-treesitter", "lewis6991/gitsigns.nvim" },
  keys = {},
  init = function()
    -- The following options are recommended when layout == "float"
    vim.opt.wrap = false
    vim.opt.sidescrolloff = 120 -- Set a large value

    --- Put your configuration here
    vim.g.neominimap = {
      auto_enable = true,
      x_multiplier = 3,
      y_multiplier = 1,
      search = {
        enabled = false,
      },
    }
  end,
}
