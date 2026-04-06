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

    -- 背景透過（前景色を保持しつつ背景だけ透明にする）
    local transparent_groups = {
      "Normal", "NormalNC", "NormalFloat",
      "SignColumn", "EndOfBuffer",
      "StatusLine", "StatusLineNC", "TabLineFill",
      "LineNr", "LineNrAbove", "LineNrBelow",
      "CursorLineNr", "CursorColumn",
      "Folded", "FoldColumn",
      "VertSplit", "WinSeparator",
    }
    for _, group in ipairs(transparent_groups) do
      local hl = vim.api.nvim_get_hl(0, { name = group })
      -- reverse属性がある場合、視覚上のfgはbg値なので入れ替える
      if hl.reverse then
        hl.fg = hl.bg or hl.fg
        hl.reverse = false
      end
      hl.bg = nil
      hl.ctermbg = nil
      vim.api.nvim_set_hl(0, group, hl)
    end

    -- CursorLineも背景透過
    local cl = vim.api.nvim_get_hl(0, { name = "CursorLine" })
    cl.bg = nil
    cl.ctermbg = nil
    vim.api.nvim_set_hl(0, "CursorLine", cl)
  end,
}
