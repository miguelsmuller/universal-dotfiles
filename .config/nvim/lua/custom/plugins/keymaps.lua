-- lua/custom/keymaps.lua

vim.keymap.set('n', '<leader>ll', '<cmd>Lazy<cr>', { desc = 'Lazy home' })
vim.keymap.set('n', '<leader>ls', '<cmd>Lazy sync<cr>', { desc = 'Lazy sync' })
vim.keymap.set('n', '<leader>lu', '<cmd>Lazy update<cr>', { desc = 'Lazy update' })

return {}
