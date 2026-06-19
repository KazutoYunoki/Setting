# 現状構成 調査レポート

調査日: 2026-06-19
対象ホスト: Linux Mint 22.2 (Zara) / ユーザー `kazutoyunoki`

このドキュメントは「新しいPCでコマンド一つで同じ開発環境を再現する」ことを目標に、
現状の個人設定を棚卸ししたものです。IaC化(再現)の入力情報になります。

---

## 1. ベースOS / システム

| 項目 | 値 |
|------|----|
| ディストリ | Linux Mint 22.2 (Zara) / base: Ubuntu 24.04 |
| デスクトップ | Cinnamon |
| ログインシェル | zsh (`/usr/bin/zsh`) |
| 日本語入力 | fcitx (GTK/QT/XMODIFIERS を `.profile` で設定) |

## 2. シェル (zsh + Oh My Zsh)

- フレームワーク: **Oh My Zsh** (`~/.oh-my-zsh`)
- テーマ: `robbyrussell`
- プラグイン: `git` のみ
- 個人設定 (`~/.zshrc`):
  - NVM 初期化
  - pyenv 初期化 (`# BEGIN/END PYENV SETUP` ブロック ※ansibleが自動挿入)
  - alias: `doc='cd ~/ドキュメント'`
  - `export PATH="$HOME/.local/bin:$PATH"`
- `~/.profile`: fcitx 入力メソッド環境変数

## 3. Java

- インストール済み JDK: **OpenJDK 17** と **OpenJDK 21** (`/usr/lib/jvm/`)
- デフォルト (`java -version`): **21.0.11**
- `JAVA_HOME` は未設定
- ビルドツール: **Gradle** (`/usr/bin/gradle`, apt版) / Maven は未インストール
- `~/.m2`, `~/.gradle` あり (キャッシュ・リポジトリ。管理対象外でよい)

## 4. Python (pyenv)

- **pyenv** + **pyenv-virtualenv** (`~/.pyenv`)
- インストール済みバージョン: `3.10.13`, `3.11.6`, `3.12.3` (+ system)
- global: **3.11.6**
- 作成済み virtualenv:
  | 名前 | ベース |
  |------|--------|
  | env310 | 3.10.13 |
  | env311 | 3.11.6 |
  | blog_writer | 3.11.6 |
  | shortcutwidget | 3.12.3 |
- ※ ansible の python ロールは 3.10/3.11 と env310/env311 のみ定義 → **3.12.3 と blog_writer/shortcutwidget が未反映**

## 5. Node.js (nvm)

- **nvm** (`~/.nvm`) でインストール
- バージョン: **v24.11.1**
- ※ 現状の ansible には Node/nvm のロールが**無い**

## 6. エディタ

### Neovim
- 設定: `~/.config/nvim/init.lua` (**実ファイル / シンボリックリンクではない**)
- leader = Space、行番号・相対行番号、indent=2、`jk`でEsc
- VSCode-Neovim 連携 keymap あり
- ⚠ リポジトリの `init.lua` は**システム版より古い**(差分あり)

### VSCode
- 本体: `/usr/bin/code`
- 設定: `~/.config/Code/User/settings.json` (**実ファイル / シンボリックリンクではない**)
- ⚠ リポジトリの `settings.json` は**システム版より古い**(コメント・項目が大幅に追加されている)
- 主な設定: Material Icon Theme / formatOnSave / Prettier既定 / Java は redhat.java で整形 /
  Copilot は `"*": true`(md・plaintextのみ除外) / Neovim連携 / JetBrains Mono + リガチャ
- インストール済み拡張機能 (26個):
  ```
  anthropic.claude-code
  asvetliakov.vscode-neovim
  dsznajder.es7-react-js-snippets
  esbenp.prettier-vscode
  github.copilot / github.copilot-chat
  ms-ceintl.vscode-language-pack-ja
  ms-python.python / ms-python.vscode-pylance / ms-python.debugpy / ms-python.vscode-python-envs
  openai.chatgpt
  pkief.material-icon-theme
  redhat.ansible / redhat.java / redhat.vscode-yaml
  vmware.vscode-boot-dev-pack / vmware.vscode-spring-boot
  vscjava.* (java-pack, gradle, maven, java-debug, java-test, java-dependency,
             spring-boot-dashboard, spring-initializr)
  ```

## 7. ターミナル (GNOME Terminal)

- カスタムプロファイル名: `customize`
- フォント: **JetBrains Mono 12** (`use-system-font=false`)
- JetBrains Mono フォントはシステムにインストール済み (`/usr/share/fonts/truetype/jetbrains-mono/`)
- プロファイルは dconf に保存 (`/org/gnome/terminal/legacy/profiles:/`)

## 8. Git / SSH

- `~/.gitconfig`: user.name=KazutoYunoki / user.email=kazuto233@gmail.com
- `~/.config/git/ignore`: `**/.claude/settings.local.json`
- SSH 鍵: `~/.ssh/id_rsa` (RSA 4096) ※鍵自体は秘密、Git管理しない
- ansible common ロールが鍵を自動生成する設定あり

## 9. その他 (AIツール等の dotfile)

`~/` 直下に各種ツールの設定ディレクトリあり:
`.claude`, `.codex`, `.codeium`, `.windsurf`, `.devin`, `.cursor`系 など。
→ 管理対象に含めるかは要検討(認証情報を含むものは除外)。

---

## 10. 現状 IaC (ansible) の評価とギャップ

既存 `ansible/` の内容:
- `common` ロール: apt パッケージ(git, zsh, openjdk-17-jdk, wget, gpg) + SSH鍵生成
- `python` ロール: pyenv/pyenv-virtualenv 導入 + 3.10/3.11 + env310/env311

### 未カバー(再現できない)項目
- [ ] Oh My Zsh 本体の導入 / `.zshrc` テーマ・plugins・alias
- [ ] Java 21 (現状 21 が既定だが ansible は 17 のみ)
- [ ] Gradle
- [ ] nvm + Node.js v24
- [ ] Python 3.12.3 / virtualenv blog_writer・shortcutwidget
- [ ] Neovim 本体 + `init.lua`
- [ ] VSCode 本体 + settings.json + 拡張機能26個
- [ ] GNOME Terminal プロファイル(JetBrains Mono)
- [ ] JetBrains Mono フォント
- [ ] `.gitconfig` / `~/.config/git/ignore`
- [ ] fcitx 設定 (`.profile`)
- [ ] **dotfile のシンボリックリンク運用**(理想形)

### 整合性の問題
- リポジトリの `init.lua` / `settings.json` が実ファイルより**古い** → 先に同期が必要
- これらは現状コピーであり、**シンボリックリンクになっていない**
