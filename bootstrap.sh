#!/usr/bin/env bash
# ============================================================
# bootstrap.sh
#   新しい PC で開発環境を一発再現するためのエントリポイント。
#
#   使い方:
#     1) このリポジトリを clone:
#          git clone <repo-url> ~/gitrepo/Setting
#     2) 実行:
#          cd ~/gitrepo/Setting && ./bootstrap.sh
#
#   やること: ansible を導入し、ansible/site.yml を localhost に適用する。
# ============================================================
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_DIR="${REPO_DIR}/ansible"

echo "==> Setting repo: ${REPO_DIR}"

# 1. ansible が無ければ apt で導入(collections 同梱の 'ansible' パッケージ)
if ! command -v ansible-playbook >/dev/null 2>&1; then
  echo "==> Installing ansible ..."
  sudo apt update
  sudo apt install -y ansible
else
  echo "==> ansible already installed: $(ansible --version | head -1)"
fi

# 2. プレイブック適用 (sudo パスワードが必要なタスクは --ask-become-pass を付ける)
echo "==> Running playbook ..."
cd "${ANSIBLE_DIR}"
ansible-playbook -i inventory.ini site.yml --ask-become-pass "$@"

echo ""
echo "==> 完了。新しいシェルを開く(または 'exec zsh')と設定が反映されます。"
