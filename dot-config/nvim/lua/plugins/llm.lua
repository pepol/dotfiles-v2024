return {
  {
    "olimorris/codecompanion.nvim",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
    },
    config = function()
      require("codecompanion").setup({
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              make_vars = true,
              make_slash_commands = true,
              show_result_in_chat = true,
            },
          },
        },
      })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
  },
  {
    "carlos-algms/agentic.nvim",
    opts = {
      provider = "cursor-acp",
      acp_providers = {
        ["cursor-acp"] = {
          command = "pnpm",
          args = { "exec", "cursor-agent-acp" },
          default_mode = "plan",
        },
      },
    },
    keys = {
      {
        "<leader>ct",
        function() require("agentic").toggle() end,
        mode = { "n", "v" },
        desc = "Toggle agentic chat",
      },
      {
        "<leader>ca",
        function() require("agentic").add_selection_or_file_to_context() end,
        mode = { "n", "v" },
        desc = "Add file or selection to agent's context",
      },
      {
        "<C-,>",
        function() require("agentic").new_session() end,
        mode = { "n", "v", "i" },
        desc = "New agentic session",
      },
    },
  },
}
