-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  { import = "astrocommunity.pack.lua" },
  {
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      -- disables automatic setup of all null-ls sources
      -- opts.handlers[1] = function() end

      -- disable selene
      opts.handlers.selene = nil

      -- delete selene
      opts.ensure_installed = opts.ensure_installed or {}
      for i, v in pairs(opts.ensure_installed) do
        if v == "selene" then
          local a = vim.list_slice(opts.ensure_installed, 1, i - 1)
          local b = vim.list_slice(opts.ensure_installed, i + 1, #opts.ensure_installed)
          opts.ensure_installed = vim.list_extend(a, b)
          return
        end
      end
    end,
  },
}
