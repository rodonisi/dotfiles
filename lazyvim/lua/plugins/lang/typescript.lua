return {
  {
    "nvim-neotest/neotest",
    ft = { "typescript", "javascript" },
    dependencies = {
      "marilari88/neotest-vitest",
    },
    opts = { adapters = { "neotest-vitest" } },
  },
}
