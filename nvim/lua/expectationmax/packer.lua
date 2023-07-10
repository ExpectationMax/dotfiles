return require("packer").startup(function(use)
  -- Packer can manage itself
  use("wbthomason/packer.nvim")

  use({
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    requires = { {"nvim-lua/plenary.nvim"} }
  })

  use("ellisonleao/gruvbox.nvim")

  use({
    "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
  })

  use("neovim/nvim-lspconfig")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-nvim-lua")
  use("L3MON4D3/LuaSnip")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/nvim-cmp")
  use("onsails/lspkind.nvim")

  use({
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  })

end)
