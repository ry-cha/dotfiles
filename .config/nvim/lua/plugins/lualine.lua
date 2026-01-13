return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
    --load on setup
      require('lualine').setup {
        options = {
          theme = 'auto',
          component_separators= { left = '󰇻'},
        }
      }
    end
  }
}

