return {
	"folke/snacks.nvim",
	init = function()
		vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = "#abb2bf" })
	end,
	opts = {
		dashboard = {
			preset = {
				header = [[
   /\  /\___   __/\   /(_)_ __ ___
    /  \/ / _ \/ _ \ \ / / | '_ ` _ \
    / /\  /  __/ (_) \ V /| | | | | | |
    \_\ \/ \___|\___/ \_/ |_|_| |_| |_|
        ]],
				keys = {
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{
						icon = " ",
						key = "g",
						desc = "Find Text",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					},
					{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
					{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
				},
			},
		},
	},
}
