local opt = vim.opt
local wo = vim.wo
-- 「※」等の記号を打つと、半角文字と重なる問題がある。「※」などを全角文字の幅で表示するために設定する
opt.ambiwidth = 'double'

-- 新しい行を改行で追加した時に、ひとつ上の行のインデントを引き継がせます。
opt.autoindent = true
opt.smartindent = true
-- smartindent と cindent を両方 true にしたときは、cindent のみ true になるようです。
-- opt.cindent = true
-- カーソルが存在する行にハイライトを当ててくれます。
opt.cursorline = true

-- カーソルが存在する列にハイライトを当てたい場合、下記をtrueにする。
-- opt.cursorculumn = true

-- TABキーを押した時に、2文字分の幅を持ったTABが表示されます。
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
-- tabstop で設定した数の分の半角スペースが入力されます。
opt.expandtab = true
-- カーソル行からの相対的な行番号を表示する
opt.relativenumber = true
opt.number = true
opt.termguicolors = true

-- 不可視文字を表示する
opt.list = true
opt.listchars = {
  tab = '▸ ',       -- タブ
  trail = '-',      -- 行末の空白
  space = '.',      -- スペース
  nbsp = '+',       -- ノーブレークスペース
  eol = '$',        -- 改行
  extends = '>',    -- 右にはみ出している行
  precedes = '<',   -- 左にはみ出している行
}


vim.scriptencoding = 'utf-8'
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'

opt.swapfile = false

-- ヤンクをシステムクリップボードと共有する
opt.clipboard = 'unnamedplus'

