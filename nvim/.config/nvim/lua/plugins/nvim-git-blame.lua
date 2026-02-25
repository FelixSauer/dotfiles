-- Git Blame
return {
	-- https://github.com/f-person/git-blame.nvim
	"f-person/git-blame.nvim",
	event = "VeryLazy",
	opts = {
		enabled = true, -- disable by default, enabled only on keymap
		date_format = "%d.%m.%y %H:%M", -- more concise date format
	},
}
