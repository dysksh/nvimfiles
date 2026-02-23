return {
    -- -- GitHub Copilot (Lua実装)
    -- {
    -- 'zbirenbaum/copilot.lua',
    -- cmd = 'Copilot',
    -- event = 'InsertEnter',
    -- config = function()
    --     require('copilot').setup({
    --         copilot_node_command = 'node', -- Node.js 22 に変更した場合はパスを指定
    --  server_opts_overrides = {
    --    settings = {
    --      advanced = {
    --        -- 補完時に周辺コンテキストを増やす
    --        length_of_context = 2048,
    --      },
    --    },
    --  },
    --     suggestion = {
    --         enabled = false, -- nvim-cmp と統合するため個別サジェストは無効
    --     },
    --     panel = {
    --         enabled = false,
    --     },
    --     })
    -- end,
    -- },
    -- -- nvim-cmp への Copilot ソース追加
    -- {
    -- 'zbirenbaum/copilot-cmp',
    -- dependencies = { 'zbirenbaum/copilot.lua' },
    -- config = function()
    --     require('copilot_cmp').setup()
    -- end,
    -- },
      {
       'zbirenbaum/copilot.lua',
       cmd = 'Copilot',
       event = 'InsertEnter',
       config = function()
         require('copilot').setup({
           suggestion = {
             enabled = true,
             auto_trigger = true,  -- 入力中に自動で補完を表示
             keymap = {
               accept = '<C-l>',        -- Tab で確定（複数行まとめて）
               accept_word = '<C-w>', -- 単語単位で確定
               accept_line = '<C-j>',   -- 1行単位で確定
               next = '<M-]>',          -- 次の候補
               prev = '<M-[>',          -- 前の候補
               dismiss = '<C-]>',       -- 却下
             },
           },
           panel = { enabled = false },
         })
       end,
     },
}