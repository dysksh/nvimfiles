return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup {
        ensure_installed = { 'http', 'json' },
      }
    end,
  },
  {
    'rest-nvim/rest.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-lua/plenary.nvim',
      { 'nvim-neotest/nvim-nio', name = 'nvim-nio' },
      { 'j-hui/fidget.nvim', opts = {} },
    },
    ft = 'http',
    config = function()
      ---@type rest.Opts
      vim.g.rest_nvim = {
        request = {
          skip_ssl_verification = true,
        },
        response = {
          hooks = {
            decode_url = true,
            format = true,
          },
        },
      }

      -- レスポンスの JSON を jq でフォーマットする
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'json',
        callback = function()
          vim.opt_local.formatprg = 'jq .'
        end,
      })
      -- キーマッピング
      vim.keymap.set('n', '<leader>rr', '<cmd>Rest run<CR>', { desc = 'Run REST request' })
      vim.keymap.set('n', '<leader>rl', '<cmd>Rest last<CR>', { desc = 'Re-run last REST request' })
      vim.keymap.set('n', '<leader>ro', '<cmd>Rest open<CR>', { desc = 'Open REST result pane' })
    end,
  },
}
