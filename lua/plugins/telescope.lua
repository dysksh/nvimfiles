return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('telescope').setup {
      defaults = {
        file_ignore_patterns = { 'node_modules', '.git/' },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
    }

    local builtin = require('telescope.builtin')
    -- ファイル検索
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'ファイル検索' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'テキスト検索 (grep)' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'バッファ一覧' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'ヘルプ検索' })
    vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = '最近開いたファイル' })
    -- Git 連携
    vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = 'Git コミット履歴' })
    vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = 'Git ステータス' })
    -- コード検索
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '診断 (エラー/警告)' })
    vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'カーソル下の単語を検索' })
  end,
}
