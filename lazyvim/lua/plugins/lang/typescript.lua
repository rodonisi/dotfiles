return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
    },
    opts = {
      adapters = {
        ["neotest-vitest"] = {},
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")

      dap.adapters.chrome = {
        type = "executable",
        command = "node",
        args = { os.getenv("HOME") .. "/code/vscode-chrome-debug/out/src/chromeDebug.js" },
      }
    end,
  },
}
