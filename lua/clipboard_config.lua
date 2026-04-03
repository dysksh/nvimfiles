local uname = vim.loop.os_uname().sysname

-- WSLカーネルか判定（WSL直接でもコンテナ内でもtrue）
local function is_wsl_kernel()
  local f = io.open("/proc/version", "r")
  if f then
    local content = f:read("*a")
    f:close()
    return content:lower():find("microsoft") ~= nil
  end
  return false
end

-- WSL直接か判定（コンテナ内ではfalse）
local function is_wsl_native()
  return vim.loop.fs_stat("/proc/sys/fs/binfmt_misc/WSLInterop") ~= nil
end

if is_wsl_native() then
  -- WSL直接: win32yank.exeが使える
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 0,
  }

elseif is_wsl_kernel() then
  -- WSL上のコンテナ: win32yank.exe実行不可のためOSC 52
  -- ペーストはNeovim内キャッシュ（Windowsからの貼り付けはCtrl+Shift+V）
  local osc52 = require("vim.ui.clipboard.osc52")
  local cache = {}
  local osc52_copy_plus = osc52.copy("+")
  local osc52_copy_star = osc52.copy("*")
  vim.g.clipboard = {
    name = "osc52-wsl-container",
    copy = {
      ["+"] = function(lines)
        cache["+"] = lines
        osc52_copy_plus(lines)
      end,
      ["*"] = function(lines)
        cache["*"] = lines
        osc52_copy_star(lines)
      end,
    },
    paste = {
      ["+"] = function() return cache["+"] end,
      ["*"] = function() return cache["*"] end,
    },
  }

elseif uname == "Darwin" then
  -- macOS
  vim.g.clipboard = {
    name = "macOS-clipboard",
    copy = {
      ["+"] = "pbcopy",
      ["*"] = "pbcopy",
    },
    paste = {
      ["+"] = "pbpaste",
      ["*"] = "pbpaste",
    },
    cache_enabled = 0,
  }

else
  -- 素のLinux（将来のSSH先など）
  -- xclip/xsel が入っていればそれを使う
  vim.g.clipboard = {
    name = "xclip",
    copy = {
      ["+"] = "xclip -selection clipboard",
      ["*"] = "xclip -selection primary",
    },
    paste = {
      ["+"] = "xclip -selection clipboard -o",
      ["*"] = "xclip -selection primary -o",
    },
    cache_enabled = 0,
  }
end
