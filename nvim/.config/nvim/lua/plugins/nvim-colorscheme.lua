return {
  'olimorris/onedarkpro.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require("onedarkpro").setup({
      colors = {
        red    = "#e06c75",
        yellow = "#e5c07b",
        green  = "#98c379",
        cyan   = "#56b6c2",
        blue   = "#61afef",
      },
    })
    vim.cmd("colorscheme onedark")
  end
}
