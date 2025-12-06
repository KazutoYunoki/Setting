# Ansible for my local Linux PC (minimal starter)

このリポジトリは自分の PC（localhost）向けの最小限の Ansible 構成です。
目的は設定をコードとして残し、再現/復元を容易にすることです。

使い方（ローカルで実行）:

1. 必要なら ansible をインストール:
   sudo apt update && sudo apt install -y ansible

2. プレイブック実行:
   ansible-playbook -i inventory.ini site.yml

カスタマイズ:

- roles/common/vars/main.yml の packages リストを編集してインストールするパッケージを追加してください。

おすすめ:

- Git で管理して変更履歴を残す
- role を増やして dotfiles や desktop アプリ、docker などを分離する
