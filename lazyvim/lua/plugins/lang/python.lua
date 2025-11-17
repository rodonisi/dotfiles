return {
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("none-ls")
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.black)
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["python"] = { "black" },
      },
      formatters = {
        black = {
          prepend_args = {
            "--line-length",
            "120",
            "--skip-string-normalization",
          },
        },
      },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          dap = {
            dap = { justMyCode = false },
            args = { "--log-level", "DEBUG" },
            -- runner = "pytest",
            -- python = ".venv/bin/python",
            pytest_discover_instances = true,
          },
        },
      },
    },
  },
}
