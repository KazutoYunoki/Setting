# Ansible (構成管理本体)

このディレクトリは PC(localhost)の環境を再現するための Ansible 構成です。
通常はリポジトリ直下の `bootstrap.sh` から実行されます。

## 直接実行する場合

```bash
cd ansible
ansible-playbook -i inventory.ini site.yml --ask-become-pass
```

特定の role だけ適用したいとき(tags は未設定なので role を絞るなら一時的に site.yml を編集するか `--start-at-task` を利用):

```bash
# 例: dotfiles の symlink だけ確認したい (dry-run)
ansible-playbook -i inventory.ini site.yml --check --diff
```

## role 一覧

| role | 役割 |
|------|------|
| common | 基本パッケージ(git/wget/curl/gpg/build-essential/gradle) + SSH 鍵生成 |
| shell | zsh + Oh My Zsh + 既定シェルを zsh に |
| java | OpenJDK 17 / 21 |
| python | pyenv + pyenv-virtualenv + Python 各版 + venv |
| node | nvm + Node.js |
| dotfiles | `dotfiles/` のファイルをシステムへ symlink(既存は .bak へ退避) |

## カスタマイズ箇所

- パッケージ: `roles/common/vars/main.yml`
- JDK: `roles/java/vars/main.yml`
- Python バージョン/venv: `roles/python/vars/main.yml`
- Node バージョン: `roles/node/vars/main.yml`
- symlink 対象: `roles/dotfiles/vars/main.yml`

## 依存

`ansible` パッケージ(apt)に同梱の community.crypto / community.general を利用します。
`ansible-core` のみの環境では別途 `ansible-galaxy collection install community.crypto` が必要です。
