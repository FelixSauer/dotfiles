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
	opts = {
		options = {
			theme = {
				normal = {
					a = { fg = "#282c34", bg = "#61afef", gui = "bold" }, -- blue
					b = { fg = "#abb2bf", bg = "#3e4452" },
					c = { fg = "#abb2bf", bg = "NONE" },
				},
				insert = {
					a = { fg = "#282c34", bg = "#98c379", gui = "bold" }, -- green
					b = { fg = "#abb2bf", bg = "#3e4452" },
				},
				visual = {
					a = { fg = "#282c34", bg = "#c678dd", gui = "bold" }, -- purple
					b = { fg = "#abb2bf", bg = "#3e4452" },
				},
				replace = {
					a = { fg = "#282c34", bg = "#e06c75", gui = "bold" }, -- red
					b = { fg = "#abb2bf", bg = "#3e4452" },
				},
				command = {
					a = { fg = "#282c34", bg = "#e5c07b", gui = "bold" }, -- yellow
					b = { fg = "#abb2bf", bg = "#3e4452" },
				},
				inactive = {
					a = { fg = "#5c6370", bg = "NONE" },
					b = { fg = "#5c6370", bg = "NONE" },
					c = { fg = "#5c6370", bg = "NONE" },
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
	},
}
