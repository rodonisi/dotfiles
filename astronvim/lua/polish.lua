-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here
vim.api.nvim_create_augroup("neotree", {})
vim.api.nvim_create_autocmd("UiEnter", {
  desc = "Open Neotree automatically",
  group = "neotree",
  callback = function()
    if vim.fn.argc() == 0 then vim.cmd "Neotree toggle" end
  end,
})
