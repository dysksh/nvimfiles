return {
  -- LSP 基本設定
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- 自動補完
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      -- スニペット
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      -- 補完の capabilities
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- 診断の表示設定（赤波線・警告など）
      vim.diagnostic.config({
        underline = true,       -- エラー箇所に下線を表示
        virtual_text = {
          prefix = '●',         -- 行末に表示するマーク
          spacing = 4,
        },
        signs = {               -- ガター（行番号横）にアイコン表示
          text = {
            [vim.diagnostic.severity.ERROR] = 'E ',
            [vim.diagnostic.severity.WARN] = 'W ',
            [vim.diagnostic.severity.HINT] = 'H ',
            [vim.diagnostic.severity.INFO] = 'I ',
          },
          texthl = {
            [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
            [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
            [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
            [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
          },
        },
        float = {
          border = 'rounded',
          source = true,        -- エラーの発生元を表示
        },
        severity_sort = true,   -- 重要度順にソート
        update_in_insert = false,
      })

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'copilot' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
      })

      -- 補完確定後に additionalTextEdits (import 追加など) を確実に適用する
      -- gopls は resolve 時に additionalTextEdits を返すため、confirm 時点で未解決の場合がある
      cmp.event:on('confirm_done', function(event)
        local item = event.entry:get_completion_item()
        if not vim.tbl_isempty(item.additionalTextEdits or {}) then return end
        local source = event.entry.source.source  -- cmp_nvim_lsp の Source オブジェクト
        if not source or not source.client then return end
        local client = source.client
        client.request('completionItem/resolve', item, function(err, resolved)
          if err or not resolved or vim.tbl_isempty(resolved.additionalTextEdits or {}) then return end
          vim.lsp.util.apply_text_edits(resolved.additionalTextEdits, vim.api.nvim_get_current_buf(), client.offset_encoding)
        end)
      end)

      -- LSP キーマッピング（LSP がアタッチされた時のみ有効）
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- 定義・参照ジャンプ
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc = '定義へジャンプ' })
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = ev.buf, desc = '宣言へジャンプ' })
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = ev.buf, desc = '実装へジャンプ' })
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = ev.buf, desc = '参照一覧' })
          vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, { buffer = ev.buf, desc = '型定義へジャンプ' })
          -- 情報表示
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf, desc = 'ホバー情報' })
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = ev.buf, desc = 'シグネチャヘルプ' })
          -- リファクタリング
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = ev.buf, desc = 'リネーム' })
          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = ev.buf, desc = 'コードアクション' })
          vim.keymap.set('n', '<leader>F', function() vim.lsp.buf.format({ async = true }) end, { buffer = ev.buf, desc = 'フォーマット' })
          -- 診断
          vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float, { buffer = ev.buf, desc = '診断を表示' })
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { buffer = ev.buf, desc = '前の診断' })
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { buffer = ev.buf, desc = '次の診断' })
        end,
      })

      -- Go (gopls) の設定 - Neovim 0.11 の vim.lsp.config を使用
      vim.lsp.config('gopls', {
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        root_markers = { 'go.work', 'go.mod', '.git' },
        capabilities = capabilities,
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              shadow = true,
            },
            staticcheck = true,
            gofumpt = false,
            completeUnimported = true,  -- 未 import のパッケージも補完候補に出す
            diagnosticsDelay = '100ms', -- 診断計算の開始を早める（デフォルト 250ms）
          },
        },
      })
      vim.lsp.enable('gopls')

      -- Go ファイル保存時に goimports で import 整理 + フォーマットを一括実行
      -- LSP 経由より goimports CLI を直接呼ぶ方が大幅に速い
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*.go',
        callback = function()
          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          local content = table.concat(lines, '\n')
          local srcdir = vim.fn.expand('%:p:h')
          local result = vim.fn.system({ 'goimports', '-srcdir', srcdir }, content)
          if vim.v.shell_error ~= 0 then return end
          local new_lines = vim.split(result, '\n', { plain = true })
          if new_lines[#new_lines] == '' then table.remove(new_lines) end
          vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
        end,
      })

      -- 保存後に gopls へ didSave を通知して診断を即時トリガー
      vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = '*.go',
        callback = function()
          local clients = vim.lsp.get_clients({ bufnr = 0, name = 'gopls' })
          for _, client in ipairs(clients) do
            client.notify('textDocument/didSave', {
              textDocument = { uri = vim.uri_from_bufnr(0) },
            })
          end
        end,
      })

      -- ファイルを開いた直後も gopls アタッチ後に診断をトリガー
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('GoLspDiagOnOpen', {}),
        pattern = '*.go',
        callback = function(ev)
          vim.defer_fn(function()
            local clients = vim.lsp.get_clients({ bufnr = ev.buf, name = 'gopls' })
            for _, client in ipairs(clients) do
              client.notify('textDocument/didSave', {
                textDocument = { uri = vim.uri_from_bufnr(ev.buf) },
              })
            end
          end, 200)
        end,
      })
    end,
  },
}
