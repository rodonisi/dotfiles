local function format_git_hunks(bufnr)
  -- Check if autoformat is enabled (LazyVim style)
  local autoformat = vim.b[bufnr].autoformat
  if autoformat == nil then
    autoformat = vim.g.autoformat
  end
  if autoformat == nil then
    autoformat = true
  end

  if not autoformat then
    return
  end

  local gitsigns = require("gitsigns")
  local conform = require("conform")
  local hunks = gitsigns.get_hunks(bufnr)

  if hunks == nil then
    hunks = {}
    local status_ok, buf_status = pcall(vim.api.nvim_buf_get_var, bufnr, "gitsigns_status_dict")
    if not status_ok then
      buf_status = nil
    end

    -- if file is untracked format it whole
    if buf_status and buf_status.added == nil then
      hunks[1] = {
        type = "untracked", -- custom type, for later processing
        added = { start = 1, count = vim.api.nvim_buf_line_count(bufnr) },
      }
    end
  end

  for i = #hunks, 1, -1 do
    local hunk = hunks[i]
    if hunk ~= nil and hunk.type ~= "delete" then
      local start = math.max(1, hunk.added.start)
      local last = start + hunk.added.count
      -- nvim_buf_get_lines uses zero-based indexing -> subtract from last
      local last_hunk_line = vim.api.nvim_buf_get_lines(bufnr, last - 2, last - 1, true)[1]
      local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }
      conform.format({ async = false, range = range, bufnr = bufnr })
    end
  end
end

return {
  {
    "stevearc/conform.nvim",
    opts = {}, -- Remove format_on_save to avoid conflict
    init = function()
      -- Override LazyVim's default autoformat to use our hunk formatting
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("lazyvim_format", { clear = true }),
            callback = function(event)
              format_git_hunks(event.buf)
            end,
          })
        end,
      })
    end,
  },
}

