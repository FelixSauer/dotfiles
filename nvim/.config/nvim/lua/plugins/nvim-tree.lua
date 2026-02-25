return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	opts = {
		-- enable hidden files
		filesystem = {
			filtered_items = {
				visible = false, -- hide filtered items on open
				hide_gitignored = false,
				hide_dotfiles = false,
				hide_by_name = {
					".DS_Store",
					".idea",
					".vscode",
				},
				never_show = { ".git" },
			},
		},
		-- display window on the right side
		window = {
			position = "right",
		},
	},
}
