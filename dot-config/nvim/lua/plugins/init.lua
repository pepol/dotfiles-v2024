return {
  {
    "miikanissi/modus-themes.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd.colorscheme "modus"
    end,
  },
  { "neovim/nvim-lspconfig" },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git" },
  { "ntpeters/vim-better-whitespace" },
}
