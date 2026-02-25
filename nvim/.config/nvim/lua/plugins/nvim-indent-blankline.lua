-- Add indent lines to the left of the code
-- https://github.com/lukas-reineke/indent-blankline.nvim
return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	opts = {
		indent = {
			char = "▏", -- Default thin line
		},
		scope = {
			enabled = true,
		},
	},
}
