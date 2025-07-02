-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {

  ---------------------------------------------------------------------------
  -- 1. ARVORE DE ARQUIVOS
  ---------------------------------------------------------------------------
  {
    'nvim-tree/nvim-tree.lua',

    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    keys = {
      { '<leader>e', '<cmd>NvimTreeToggle<cr>', desc = 'Abrir/Fechar NvimTree' },
    },

    config = function()
      require('nvim-tree').setup {
        view = { width = 35 },
        hijack_directories = { enable = true, auto_open = true },
      }
    end,
  },
}
