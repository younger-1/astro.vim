return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      local actions = require "telescope.actions"
      return vim.tbl_deep_extend("force", opts, {
        defaults = {
          cache_picker = {
            num_pickers = 20,
          },
          dynamic_preview_title = true,
          path_display = {
            filename_first = { reverse_directories = false },
          },
          mappings = {
            i = {
              ["<A-n>"] = actions.cycle_history_next,
              ["<A-p>"] = actions.cycle_history_prev,

              ["<A-j>"] = { actions.results_scrolling_down, type = "action", opts = { desc = "nop" } },
              ["<A-k>"] = { actions.results_scrolling_up, type = "action", opts = { desc = "nop" } },
              ["<A-h>"] = { actions.results_scrolling_left, type = "action", opts = { desc = "nop" } },
              ["<A-l>"] = { actions.results_scrolling_right, type = "action", opts = { desc = "nop" } },

              ["<A-S-j>"] = { actions.preview_scrolling_down, type = "action", opts = { desc = "nop" } },
              ["<A-S-k>"] = { actions.preview_scrolling_up, type = "action", opts = { desc = "nop" } },
              ["<A-S-h>"] = { actions.preview_scrolling_left, type = "action", opts = { desc = "nop" } },
              ["<A-S-l>"] = { actions.preview_scrolling_right, type = "action", opts = { desc = "nop" } },

              ["<S-down>"] = { actions.results_scrolling_down, type = "action", opts = { desc = "nop" } },
              ["<S-up>"] = { actions.results_scrolling_up, type = "action", opts = { desc = "nop" } },
              ["<S-left>"] = { actions.results_scrolling_left, type = "action", opts = { desc = "nop" } },
              ["<S-right>"] = { actions.results_scrolling_right, type = "action", opts = { desc = "nop" } },

              ["<A-down>"] = { actions.preview_scrolling_down, type = "action", opts = { desc = "nop" } },
              ["<A-up>"] = { actions.preview_scrolling_up, type = "action", opts = { desc = "nop" } },
              ["<A-left>"] = { actions.preview_scrolling_left, type = "action", opts = { desc = "nop" } },
              ["<A-right>"] = { actions.preview_scrolling_right, type = "action", opts = { desc = "nop" } },

              ["<A-a>"] = actions.toggle_all,
              ["<A-d>"] = actions.drop_all,

              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["<C-z>"] = actions.smart_send_to_loclist + actions.open_loclist,

              ["<A-q>"] = actions.smart_add_to_qflist + actions.open_qflist,
              ["<A-z>"] = actions.smart_add_to_loclist + actions.open_loclist,
            },
          },
        },
        pickers = {
          -- @see https://www.reddit.com/r/neovim/comments/1hdwv63/a_tip_to_improve_telescope_find_files_experience/
          find_files = {
            default_text = "'",
            on_complete = {
              function()
                vim.schedule(function()
                  local action_state = require "telescope.actions.state"
                  local prompt_bufnr = require("telescope.state").get_existing_prompt_bufnrs()[1]

                  local picker = action_state.get_current_picker(prompt_bufnr)
                  if picker == nil then return end
                  local results = picker.layout.results
                  local bufnr = results.bufnr
                  local winid = results.winid
                  local count = vim.api.nvim_buf_line_count(bufnr)
                  if count == 1 and vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1] == "" then
                    local line = vim.api.nvim_buf_get_lines(prompt_bufnr, 0, -1, false)[1]
                    local new_line = line:gsub("'", " ")
                    vim.api.nvim_buf_set_lines(prompt_bufnr, 0, -1, false, { new_line })
                  end
                end)
              end,
            },
          },
        },
      })
    end,
    keys = {
      { "<leader>s<space>", "<cmd>Telescope resume<cr>", desc = "Resume" },
      { "<leader>su", "<cmd>Telescope pickers<cr>", desc = "Pickers" },
      {
        mode = "x",
        "<leader>sg",
        function()
          local text = require("util").get_visual_selection()
          require("telescope.builtin").live_grep {}
          vim.fn.feedkeys(text)
        end,
        desc = "Grep",
      },
      {
        mode = "x",
        "<leader>sw",
        function()
          require("telescope.builtin").grep_string {
            search = require("util").get_visual_selection_by_reg(),
          }
        end,
        desc = "Word",
      },
      --
      { "<leader>fr", "<cmd>Telescope oldfiles only_cwd=true<cr>", desc = "Recent (cwd)" },
      { "<leader>fR", "<cmd>Telescope oldfiles<cr>", desc = "Recent file" },
      {
        mode = "x",
        "<leader>ff",
        function()
          local text = require("util").get_visual_selection()
          require("telescope.builtin").find_files {}
          vim.fn.feedkeys(text)
        end,
        desc = "Find file",
      },
      --
      { "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Status" },
      { "<leader>gS", "<cmd>Telescope git_stash<cr>", desc = "Stash" },
      { "<leader>gC", "<cmd>Telescope git_bcommits<CR>", desc = "Buffer commits" },
      { "<leader>gl", "<cmd>Telescope git_bcommits_range<cr>", desc = "Line commits" },
      {
        mode = "x",
        "<leader>gl",
        function()
          -- vim.fn.feedkeys(vim.keycode("<Esc>"))
          require("telescope.builtin").git_bcommits_range {
            from = vim.fn.line "'<",
            to = vim.fn.line "'>",
          }
        end,
        desc = "Line commits",
      },
    },
    dependencies = {
      {
        "nvim-telescope/telescope-smart-history.nvim",
        dependencies = {
          { "kkharji/sqlite.lua" },
        },
        specs = {
          {
            "nvim-telescope/telescope.nvim",
            opts = {
              defaults = {
                history = {
                  path = vim.fs.joinpath(vim.fn.stdpath "data", "telescope_history.sqlite3"),
                  limit = 500,
                },
              },
            },
          },
        },
        init = function()
          -- To enable extension's setting
          require("astrocore").on_load(
            "telescope.nvim",
            function() require("telescope").load_extension "smart_history" end
          )
        end,
      },
    },
  },
  {
    "tsakirist/telescope-lazy.nvim",
    keys = {
      {
        "<leader>sx",
        "<cmd>Telescope lazy<cr>",
        desc = "Lazy plugins",
      },
    },
    specs = {
      {
        "nvim-telescope/telescope.nvim",
        opts = {
          extensions = {
            lazy = {
              theme = "ivy",
              show_icon = true,
              mappings = {
                open_in_browser = "<C-o>",
                open_in_find_files = "<C-f>",
                open_in_live_grep = "<C-g>",
                open_in_file_browser = "<C-b>",
                open_in_terminal = "<C-t>",
                open_plugins_picker = "<C-o>", -- Works only after having called first another action
                open_lazy_root_find_files = "<C-r>f",
                open_lazy_root_live_grep = "<C-r>g",
                change_cwd_to_plugin = "<C-r>d",
              },
            },
          },
        },
      },
    },
    config = function() require("telescope").load_extension "lazy" end,
  },
}
