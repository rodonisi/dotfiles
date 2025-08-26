return {
  {
    "microsoft/vscode-js-debug",
    opt = true,
    run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    requires = { "mfussenegger/nvim-dap" },
    ft = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
    opts = {
      adapters = { "node", "chrome" },
    },
  },
}
