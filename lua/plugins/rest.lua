return {
  {
    'mistweaverco/kulala.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = 'http',
    opts = {
      global_keymaps = false,
    },
    config = function(_, opts)
      require('kulala').setup(opts)

      vim.keymap.set('n', '<leader>rr', '<cmd>lua require("kulala").run()<CR>', { desc = 'Run REST request' })
      vim.keymap.set('n', '<leader>rl', '<cmd>lua require("kulala").replay()<CR>', { desc = 'Re-run last REST request' })
      vim.keymap.set('n', '<leader>ro', '<cmd>lua require("kulala").toggle_view()<CR>', { desc = 'Toggle REST result view' })
    end,
  },
}
