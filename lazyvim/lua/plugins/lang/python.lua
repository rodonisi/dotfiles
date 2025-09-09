return {
  {
    "nvim-neotest/neotest",
    ft = "python",
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = { adapters = { "neotest-python" } },
  },
}
