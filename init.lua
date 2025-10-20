-- ===============================
-- VSCode Neovim 設定（init.lua）
-- ===============================

-- リーダーキー設定
vim.g.mapleader = " "

-- 基本設定
vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2

-- ===============================
-- VSCode内でのみ有効にする設定
-- ===============================
if vim.g.vscode then
  -- ノーマルモード用
  local keymap = vim.keymap.set
  local opts = { noremap = true, silent = true }

  -- VSCode コマンド呼び出し（VSCode側のアクションを実行）
  local function vscode_cmd(cmd)
    return function()
      vim.fn.VSCodeNotify(cmd)
    end
  end
  
  -- ~/.config/nvim/init.lua または %USERPROFILE%\AppData\Local\nvim\init.lua
  
  -- ファイルを右のペインに移動
  keymap("n", "<C-l>", vscode_cmd("workbench.action.moveEditorToNextGroup"), opts)

  -- ファイルを左のペインに移動
  keymap("n", "<C-h>", vscode_cmd("workbench.action.moveEditorToPreviousGroup"), opts)

  -- エクスプローラにフォーカス
  keymap("n", "<C-e>", vscode_cmd("workbench.view.explorer"), opts)

  -- ターミナルにフォーカス
  keymap("n", "<C-t>", vscode_cmd("workbench.action.terminal.focus"), opts)

  -- Hover 表示
  keymap("n", "<C-i>", vscode_cmd("editor.action.showHover"), opts)

else
  -- ===============================
  -- 通常Neovimとして開いたとき
  -- ===============================
  vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

  -- よく使う設定例（お好みで）
  vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true })
end
