return {
	"folke/snacks.nvim",
	init = function()
		vim.api.nvim_set_hl(0, "SnacksDashboardHeader1", { fg = "#2bbac5" })
		vim.api.nvim_set_hl(0, "SnacksDashboardHeader2", { fg = "#61afef" })
		vim.api.nvim_set_hl(0, "SnacksDashboardHeader3", { fg = "#d55fde" })
	end,
	opts = {
		dashboard = {
			preset = {
				keys = {
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "g",
						desc = "Find Text",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					},
					{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
					{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
				},
			},
			sections = {
				{
					{
						text = {
							{ "   /\\  /\\___   __/\\   /(_)_ __ ___", hl = "SnacksDashboardHeader1" },
						},
						align = "center",
					},
					{
						text = {
							{ "    /  \\/ / _ \\/ _ \\ \\ / / | '_ ` _ \\", hl = "SnacksDashboardHeader2" },
						},
						align = "center",
					},
					{
						text = {
							{ "    / /\\  /  __/ (_) \\ V /| | | | | | |", hl = "SnacksDashboardHeader2" },
						},
						align = "center",
					},
					{
						text = {
							{ "    \\_\\ \\/ \\___|\\___ /\\_/ |_|_| |_| |_|", hl = "SnacksDashboardHeader3" },
						},
						align = "center",
					},
					padding = 1,
				},
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "startup" },
			},
		},
	},
}
