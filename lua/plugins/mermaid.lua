return {
  -- Markdown / Mermaid のブラウザプレビュー
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      -- ブラウザを自動で開く
      vim.g.mkdp_auto_start = 0
      -- ファイルを閉じたらプレビューも閉じる
      vim.g.mkdp_auto_close = 1
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Markdown Preview Toggle" },
    },
  },
}
