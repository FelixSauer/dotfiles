-- Load: lua require("nvim-lazydocker")
-- Description: nvim-lazydocker configuration files
-- Lazydocker is a simple terminal UI for both docker and docker-compose, written in Go with the gocui library.
return {
	"mgierada/lazydocker.nvim",
	dependencies = { "akinsho/toggleterm.nvim" },
	config = function()
		require("lazydocker").setup({
			border = "curved", -- valid options are "single" | "double" | "shadow" | "curved"
		})
	end,
	event = "BufRead",
	keys = {
		{
			"<leader>ld",
			function()
				require("lazydocker").open()
			end,
			desc = "Open Lazydocker floating window",
		},
	},
}
