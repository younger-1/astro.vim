return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      {
        "<leader>e",
        function()
          local dir = require("astrocore.rooter").detect()[1]
          dir = dir and dir.paths and dir.paths[1]
          require("neo-tree.command").execute { toggle = true, dir = dir }
        end,
        desc = "NeoTree (Root Dir)",
      },
      {
        "<leader>E",
        function() require("neo-tree.command").execute { toggle = true, dir = vim.uv.cwd() } end,
        desc = "NeoTree (cwd)",
      },
    },
  },
}
