return {
  {
    "olimorris/codecompanion.nvim",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
      "ravitemer/codecompanion-history.nvim",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            template = "[Image]($FILE_PATH)",
            use_absolute_path = true,
          },
        },
      },
    },
    keys = {
      { "<leader>ca", "<cmd>CodeCompanionActions<cr>", desc = "AI: actions" },
      { "<leader>ct", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI: chat" },
      { "<leader>ch", "<cmd>CodeCompanionHistory<cr>", desc = "AI: history" },
      { "<leader>cf", "<cmd>CodeCompanionChat Add<cr>", desc = "AI: add file to chat", mode = { "v" } },
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "cursor",
            slash_commands = {
              file = default_picker_opts,
              buffer = default_picker_opts,
              buffers = default_picker_opts,

              files = default_picker_opts,
              cwd = default_picker_opts,

              git_file = default_picker_opts,
              git_files = default_picker_opts,
              git_diff = default_picker_opts,
              git_commit = default_picker_opts,

              diagnostic = default_picker_opts,
              symbols = default_picker_opts,

              help = default_picker_opts,
              recent = default_picker_opts,
              time = default_picker_opts,
              date = default_picker_opts,
            },
          },
        },
        adapters = {
          acp = {
            opts = {
              show_presets = false,
            },
            cursor = function()
              return require("codecompanion.adapters.acp").extend("claude_code", {
                name = "cursor",
                formatted_name = "Cursor",
                commands = {
                  default = {
                    "pnpm",
                    "exec",
                    "cursor-agent-acp",
                  },
                },
              })
            end
          },
        },
        display = {
          action_pallette = {
            provider = "default",
          },
        },
        interactions = {
          chat = {
            icons = {
              chat_context = "ctx",
            },
            fold_context = true,
            fold_reasoning = true,
            show_reasoning = true,
            tools = {
              ["cmd_runner"] = {
                opts = {
                  require_approval_before = true,
                },
              },
            },
          },
        },
        extensions = {
          history = {
            enabled = true,
            opts = {
              auto_generate_title = false,
            },
          },
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
    ft = { "markdown", "codecompanion", "AgenticChat" },
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
        "<leader>at",
        function() require("agentic").toggle() end,
        mode = { "n", "v" },
        desc = "AI: Toggle agentic chat",
      },
      {
        "<leader>aa",
        function() require("agentic").add_selection_or_file_to_context() end,
        mode = { "n", "v" },
        desc = "AI: Add file or selection to agent's context",
      },
      {
        "<leader>an",
        function() require("agentic").new_session() end,
        mode = { "n", "v" },
        desc = "New agentic session",
      },
    },
  },
}
