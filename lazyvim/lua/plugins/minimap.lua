return {
  "Isrothy/neominimap.nvim",
  lazy = false, -- NOTE: NO NEED to Lazy load
  dependencies = { "nvim-treesitter/nvim-treesitter", "lewis6991/gitsigns.nvim", "nvim-mini/mini.diff" },
  keys = {},
  init = function()
    -- The following options are recommended when layout == "float"
    vim.opt.wrap = false
    vim.opt.sidescrolloff = 36 -- Set a large value

    --- Put your configuration here
    ---@type Neominimap.UserConfig
    vim.g.neominimap = {
      auto_enable = true,
    }
  end,
}
