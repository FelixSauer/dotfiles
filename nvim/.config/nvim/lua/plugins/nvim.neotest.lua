return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
    "nvim-neotest/neotest-plenary",
    "nvim-neotest/neotest-vim-test",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-python")({
          dap = { justMyCode = false },
        }),
        require("neotest-plenary"),
        require("neotest-vim-test")({
          ignore_file_types = { "python", "vim", "lua" },
        }),
      },
    })

    -- Keymaps
    local keymap = vim.keymap.set
    local opts = { silent = true, noremap = true }

    keymap("n", "<leader>tt", function()
      require("neotest").run.run()
    end, vim.tbl_extend("force", opts, { desc = "Run nearest test" }))

    keymap("n", "<leader>tf", function()
      require("neotest").run.run(vim.fn.expand("%"))
    end, vim.tbl_extend("force", opts, { desc = "Run tests in current file" }))

    keymap("n", "<leader>td", function()
      require("neotest").run.run({ strategy = "dap" })
    end, vim.tbl_extend("force", opts, { desc = "Debug nearest test" }))

    keymap("n", "<leader>ts", function()
      require("neotest").run.stop()
    end, vim.tbl_extend("force", opts, { desc = "Stop running tests" }))

    keymap("n", "<leader>to", function()
      require("neotest").output.open({ enter = true })
    end, vim.tbl_extend("force", opts, { desc = "Open test output" }))

    keymap("n", "<leader>tS", function()
      require("neotest").summary.toggle()
    end, vim.tbl_extend("force", opts, { desc = "Toggle test summary" }))

    keymap("n", "]t", function()
      require("neotest").jump.next({ status = "failed" })
    end, vim.tbl_extend("force", opts, { desc = "Jump to next failed test" }))

    keymap("n", "[t", function()
      require("neotest").jump.prev({ status = "failed" })
    end, vim.tbl_extend("force", opts, { desc = "Jump to previous failed test" }))
  end,
}