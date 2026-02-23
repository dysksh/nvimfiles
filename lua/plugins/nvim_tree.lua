return {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('nvim-tree').setup({
      sort_by = 'case_sensitive',
      view = {
        adaptive_size = true,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
    })

    -- start neovim with open nvim-tree
    require("nvim-tree.api").tree.toggle(false, true)

    -- キーマッピング
    vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeFocus<CR>', { desc = 'ファイルツリーにフォーカス' })
    -- a ファイル作成
    -- d ファイル削除
    -- r ファイル名変更
    -- aで末尾に/を付けるとディレクトリ作成
  end,
}
