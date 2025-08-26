-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.dart" },
  { import = "astrocommunity.pack.python-ruff" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.prettier" },

  { import = "astrocommunity.completion.copilot-lua-cmp" },

  { import = "astrocommunity.recipes.vscode" },
}
