return {
  {
    'mistweaverco/kulala.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = 'http',
    opts = {
      global_keymaps = false,
      default_view = 'body',
      additional_curl_options = { '--insecure', '--cookie-jar', '/tmp/kulala-cookies.txt', '--cookie', '/tmp/kulala-cookies.txt' },
    },
    config = function(_, opts)
      require('kulala').setup(opts)

      vim.keymap.set('n', '<leader>rr', '<cmd>lua require("kulala").run()<CR>', { desc = 'Run REST request' })
      vim.keymap.set('n', '<leader>rl', '<cmd>lua require("kulala").replay()<CR>', { desc = 'Re-run last REST request' })
      vim.keymap.set('n', '<leader>ro', '<cmd>lua require("kulala").toggle_view()<CR>', { desc = 'Toggle REST result view' })

      vim.api.nvim_create_autocmd('BufWinEnter', {
        pattern = 'kulala://ui',
        callback = function()
          vim.opt_local.foldenable = false
        end,
      })

      local function url_decode(str)
        return (str:gsub('+', ' '):gsub('%%(%x%x)', function(h)
          return string.char(tonumber(h, 16))
        end))
      end

      -- ビジュアル選択範囲をURLデコードしてその場で置換
      vim.keymap.set('v', '<leader>rd', function()
        local s = vim.fn.getpos("'<")
        local e = vim.fn.getpos("'>")
        local lines = vim.api.nvim_buf_get_text(0, s[2] - 1, s[3] - 1, e[2] - 1, e[3], {})
        local selected = table.concat(lines, '\n')
        local decoded = url_decode(selected)
        vim.api.nvim_buf_set_text(0, s[2] - 1, s[3] - 1, e[2] - 1, e[3], vim.split(decoded, '\n'))
      end, { desc = 'URL decode selected text' })
    end,
  },
}
