-- Status line plugin
return {
	-- https://github.com/nvim-lualine/lualine.nvim
	"nvim-lualine/lualine.nvim",
	dependencies = {
		-- https://github.com/nvim-tree/nvim-web-devicons
		"nvim-tree/nvim-web-devicons", -- fancy icons
		-- https://github.com/linrongbin16/lsp-progress.nvim
		"linrongbin16/lsp-progress.nvim", -- LSP loading progress
	},
	config = function()
		local c = require("onedarkpro.helpers").get_colors()

		require("lualine").setup({
			options = {
				theme = {
					normal = {
						a = { fg = c.bg, bg = c.blue,   gui = "bold" },
						b = { fg = c.fg, bg = c.bg },
						c = { fg = c.fg, bg = "NONE" },
					},
					insert = {
						a = { fg = c.bg, bg = c.green,  gui = "bold" },
						b = { fg = c.fg, bg = c.bg },
					},
					visual = {
						a = { fg = c.bg, bg = c.purple, gui = "bold" },
						b = { fg = c.fg, bg = c.bg },
					},
					replace = {
						a = { fg = c.bg, bg = c.red,    gui = "bold" },
						b = { fg = c.fg, bg = c.bg },
					},
					command = {
						a = { fg = c.bg, bg = c.yellow, gui = "bold" },
						b = { fg = c.fg, bg = c.bg },
					},
					inactive = {
						a = { fg = c.gray, bg = "NONE" },
						b = { fg = c.gray, bg = "NONE" },
						c = { fg = c.gray, bg = "NONE" },
					},
				},
			},
			sections = {
				lualine_c = {
					{
						-- Customize the filename part of lualine to be parent/filename
						"filename",
						file_status = true, -- Displays file status (readonly status, modified status)
						newfile_status = false, -- Display new file status (new file means no write after created)
						path = 4, -- 0: Just the filename
						-- 1: Relative path
						-- 2: Absolute path
						-- 3: Absolute path, with tilde as the home directory
						-- 4: Filename and parent dir, with tilde as the home directory
						symbols = {
							modified = "[+]", -- Text to show when the file is modified.
							readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
						},
					},
				},
				lualine_x = { "encoding", "filetype" },
				lualine_y = { "location" },
				lualine_z = {
					function()
						return os.date("%R")
					end,
				},
			},
		})
	end,
}
