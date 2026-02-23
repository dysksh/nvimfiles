return {
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        signs = {
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
        },
        -- 現在行の blame をバーチャルテキストで表示 (GitLens風)
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 300,
        },
        current_line_blame_formatter = '  <author>, <author_time:%Y-%m-%d> - <summary>',
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- hunk 間の移動
          map('n', ']c', function() gs.nav_hunk('next') end, { desc = '次の変更箇所へ' })
          map('n', '[c', function() gs.nav_hunk('prev') end, { desc = '前の変更箇所へ' })

          -- hunk 操作
          map('n', '<leader>hs', gs.stage_hunk, { desc = 'Hunk をステージ' })
          map('n', '<leader>hr', gs.reset_hunk, { desc = 'Hunk をリセット' })
          map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'ステージを取り消し' })
          map('n', '<leader>hp', gs.preview_hunk, { desc = 'Hunk をプレビュー' })
          map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, { desc = '行の blame 詳細' })
          map('n', '<leader>hd', gs.diffthis, { desc = '差分を表示' })
          map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Blame 表示の切替' })
        end,
      })
    end,
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
    init = function()
      vim.keymap.set('n', '<leader>dv', '<cmd>DiffviewOpen<CR>', { desc = 'Diffview を開く' })
      vim.keymap.set('n', '<leader>do', '<cmd>DiffviewOpen develop..HEAD<CR>', { desc = 'Diffview（develop..HEAD） を開く' })
      vim.keymap.set('n', '<leader>dh', '<cmd>DiffviewFileHistory %<CR>', { desc = '現在ファイルの履歴' })
      vim.keymap.set('n', '<leader>da', '<cmd>DiffviewFileHistory<CR>', { desc = '全ファイルの履歴' })
      vim.keymap.set('n', '<leader>dc', '<cmd>DiffviewClose<CR>', { desc = 'Diffview を閉じる' })
    end,
    config = function()
      local actions = require('diffview.actions')
      require('diffview').setup({
        file_panel = {
          listing_style = 'tree',
          win_config = {
            position = 'left',
            width = math.max(30, math.min(60, math.floor(vim.o.columns * 0.2))),
          },
        },
        keymaps = {
          file_panel = {
            -- Enter でファイルを開いた後、差分ペインにフォーカスを移す
            { 'n', '<cr>', actions.focus_entry, { desc = 'ファイルを開いてフォーカス移動' } },
          },
        },
      })
      -- diff 表示で省略せず全行表示する
      vim.opt.diffopt:append('context:99999')
    end,
  },
}
