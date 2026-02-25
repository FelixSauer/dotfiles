-- Description: nvim-kube-utils configuration
-- nvim-kube-utils is a plugin that provides a set of utilities for working with Kubernetes resources in Neovim.
return {
	{
		"h4ckm1n-dev/kube-utils-nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		lazy = true,
		event = "VeryLazy",
	},
}
