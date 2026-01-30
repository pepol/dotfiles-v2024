return {
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({"]c", bang = true})
          else
            gitsigns.nav_hunk("next")
          end
        end)

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({"[c", bang = true})
          else
            gitsigns.nav_hunk("prev")
          end
        end)

        -- Actions
        map("n", "<leader>hs", gitsigns.stage_hunk)
        map("n", "<leader>hr", gitsigns.reset_hunk)

        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)

        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)

        map("n", "<leader>hS", gitsigns.stage_buffer)
        map("n", "<leader>hR", gitsigns.reset_buffer)
        map("n", "<leader>hp", gitsigns.preview_hunk)
        map("n", "<leader>hi", gitsigns.preview_hunk_inline)

        map("n", "<leader>hb", function()
          gitsigns.blame_line({ full = true })
        end)

        map("n", "<leader>hd", gitsigns.diffthis)

        map("n", "<leader>hD", function()
          gitsigns.diffthus("~")
        end)

        map("n", "<leader>hQ", function() gitsigns.setqflist("all") end)
        map("n", "<leader>hq", gitsigns.setqflist)

        -- Toggles
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
        map("n", "<leader>tw", gitsigns.toggle_word_diff)

        -- Text objects
        map({"o", "x"}, "ih", gitsigns.select_hunk)
      end
    },
  },
  {
    "ldelossa/gh.nvim",
    dependencies = {
      {
        "ldelossa/litee.nvim",
        config = function()
          require("litee.lib").setup()
        end,
      },
    },
    config = function()
      require("litee.gh").setup()
      local wk = require("which-key")
      wk.add {
        { '<leader>g', group = 'Git' },
        { '<leader>gh', group = 'Github' },
        { '<leader>ghc', group = 'Commits' },
        { '<leader>ghcc', '<cmd>GHCloseCommit<cr>', desc = 'Close' },
        { '<leader>ghce', '<cmd>GHExpandCommit<cr>', desc = 'Expand' },
        { '<leader>ghco', '<cmd>GHOpenToCommit<cr>', desc = 'Open To' },
        { '<leader>ghcp', '<cmd>GHPopOutCommit<cr>', desc = 'Pop Out' },
        { '<leader>ghcz', '<cmd>GHCollapseCommit<cr>', desc = 'Collapse' },
        { '<leader>ghi', group = 'Issues' },
        { '<leader>ghip', '<cmd>GHPreviewIssue<cr>', desc = 'Preview' },
        { '<leader>ghl', group = 'Litee' },
        { '<leader>ghlt', '<cmd>LTPanel<cr>', desc = 'Toggle Panel' },
        { '<leader>ghp', group = 'Pull Request' },
        { '<leader>ghpc', '<cmd>GHClosePR<cr>', desc = 'Close' },
        { '<leader>ghpd', '<cmd>GHPRDetails<cr>', desc = 'Details' },
        { '<leader>ghpe', '<cmd>GHExpandPR<cr>', desc = 'Expand' },
        { '<leader>ghpo', '<cmd>GHOpenPR<cr>', desc = 'Open' },
        { '<leader>ghpp', '<cmd>GHPopOutPR<cr>', desc = 'PopOut' },
        { '<leader>ghpr', '<cmd>GHRefreshPR<cr>', desc = 'Refresh' },
        { '<leader>ghpt', '<cmd>GHOpenToPR<cr>', desc = 'Open To' },
        { '<leader>ghpz', '<cmd>GHCollapsePR<cr>', desc = 'Collapse' },
        { '<leader>ghr', group = 'Review' },
        { '<leader>ghrb', '<cmd>GHStartReview<cr>', desc = 'Begin' },
        { '<leader>ghrc', '<cmd>GHCloseReview<cr>', desc = 'Close' },
        { '<leader>ghrd', '<cmd>GHDeleteReview<cr>', desc = 'Delete' },
        { '<leader>ghre', '<cmd>GHExpandReview<cr>', desc = 'Expand' },
        { '<leader>ghrs', '<cmd>GHSubmitReview<cr>', desc = 'Submit' },
        { '<leader>ghrz', '<cmd>GHCollapseReview<cr>', desc = 'Collapse' },
        { '<leader>ght', group = 'Threads' },
        { '<leader>ghtc', '<cmd>GHCreateThread<cr>', desc = 'Create' },
        { '<leader>ghtn', '<cmd>GHNextThread<cr>', desc = 'Next' },
        { '<leader>ghtt', '<cmd>GHToggleThread<cr>', desc = 'Toggle' },
      }
    end,
  },
  {
    "comatory/gh-co.nvim",
    config = function()
      local wk = require("which-key")
      wk.add {
        { '<leader>gho', '<cmd>GhCoWho<cr>', desc = 'Code Owners' },
      }
    end
  },
}
