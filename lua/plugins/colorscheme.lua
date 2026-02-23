-- カラーテーマを設定します。
return {
  'cocopon/iceberg.vim',
  lazy = false,
  priority = 1000, -- カラースキームは最優先で読み込む
  config = function()
    vim.cmd [[
      try
        colorscheme iceberg
      catch /^Vim\%((\a\+)\)\=:E185/
        colorscheme default
        set background=dark
      endtry
    ]]
  end,
}
