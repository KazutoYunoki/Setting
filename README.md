# Setting — PC 環境の構成管理 (IaC)

自分の Linux PC の開発環境・各種設定を **コードとして管理** し、
新しい PC でも **コマンド一つで同じ環境を再現** することを目的としたリポジトリです。

- ベース: Linux Mint 22.2 (Ubuntu 24.04) / zsh
- 構成管理: **Ansible**
- dotfiles: リポジトリを正とし、システムからは **シンボリックリンク** で参照

> 現状構成の調査結果は [docs/CURRENT-STATE.md](docs/CURRENT-STATE.md) を参照。

---

## クイックスタート(新しい PC)

```bash
git clone <repo-url> ~/gitrepo/Setting
cd ~/gitrepo/Setting
./bootstrap.sh
```

`bootstrap.sh` が ansible を導入し、`ansible/site.yml` を localhost に適用します。
完了後、新しいシェルを開く(`exec zsh`)と設定が反映されます。

---

## リポジトリ構成

```
Setting/
├── bootstrap.sh            # ワンコマンド実行エントリポイント
├── dotfiles/               # 設定ファイルの「正」(symlink 元)
│   ├── zshrc               #   -> ~/.zshrc
│   ├── gitconfig           #   -> ~/.gitconfig
│   └── config/
│       ├── nvim/init.lua            # -> ~/.config/nvim/init.lua
│       ├── git/ignore               # -> ~/.config/git/ignore
│       └── Code/User/settings.json  # -> ~/.config/Code/User/settings.json
├── ansible/
│   ├── site.yml            # 適用する role の一覧
│   ├── inventory.ini       # localhost
│   ├── ansible.cfg
│   ├── host_vars/localhost.yml
│   └── roles/
│       ├── common/         # 基本パッケージ + SSH 鍵
│       ├── shell/          # zsh + Oh My Zsh + 既定シェル
│       ├── java/           # OpenJDK 17 / 21
│       ├── python/         # pyenv + virtualenv
│       ├── node/           # nvm + Node.js
│       └── dotfiles/       # dotfiles を symlink で配置
└── docs/
    └── CURRENT-STATE.md    # 現状構成の調査レポート
```

---

## 何が再現されるか (今回のスコープ)

| 領域 | 内容 |
|------|------|
| シェル | zsh + Oh My Zsh (theme: robbyrussell)、既定シェル切替 |
| dotfiles | `.zshrc` / `.gitconfig` / nvim / git ignore / VSCode settings を symlink |
| Java | OpenJDK 17 / 21、Gradle |
| Python | pyenv + 3.10/3.11/3.12 + virtualenv 群 |
| Node | nvm + Node.js v24 |

### 今回スコープ外(別途検討)
- VSCode 本体のインストール / 拡張機能の自動導入
- GNOME Terminal プロファイル / JetBrains Mono フォント
- fcitx (日本語入力) の設定

---

## dotfiles の運用方針

- **編集は必ず `dotfiles/` 配下のファイルに対して行う**(システム側は symlink)。
- ansible 適用時、既存の実ファイルがあれば `*.bak-<日時>` にバックアップしてから symlink に置き換えます。
- 設定を変えたら、その差分を git commit すれば履歴として残ります。

## カスタマイズ

- インストールパッケージ: `ansible/roles/common/vars/main.yml`
- Python のバージョン/venv: `ansible/roles/python/vars/main.yml`
- Node のバージョン: `ansible/roles/node/vars/main.yml`
- symlink するファイル: `ansible/roles/dotfiles/vars/main.yml`

## セキュリティ

- SSH 秘密鍵・トークン・認証情報は **コミットしません**(ルート `.gitignore` で除外)。
- SSH 鍵は `common` role が新規生成します(既存があれば再利用)。
