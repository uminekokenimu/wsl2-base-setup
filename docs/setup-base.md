# ベースイメージ作成手順

WSL2ベースイメージの詳細な作成手順です。

## 前提条件

- Windows 11
- WSL2が有効化されていること
- PowerShellの管理者権限

---

## 1. 新規WSL2インスタンスの作成
```powershell
wsl --install -d Ubuntu-24.04 --name ubuntu-base
```
初回起動時の設定：
```
Enter new UNIX username: baseuser
New password: baseuser
```

**重要**: このユーザーは一時的なものです。
- ユーザー名: `baseuser`（固定）
- パスワード: `baseuser`（シンプルなもの）

このユーザーはベースイメージ作成にのみ使用し、**各自の環境で削除します**。

---

## 2. ホームディレクトリに移動
```bash
cd ~
```

---

## 3. リポジトリのクローン
```bash
git clone https://github.com/uminekokenimu/wsl2-base-setup.git
```
```bash
cd wsl2-base-setup
```
※Gitがインストールされていない場合はをインストールしてください。

---

## 4. セットアップスクリプトの実行
```bash
chmod +x setup.sh install-docker.sh
```
```bash
./setup.sh
```

### スクリプトが行うこと

1. システムパッケージの更新
2. keychainのインストール（SSH Agent管理用）
3. Dockerの公式インストール
5. `/etc/wsl.conf`に[network]セクションを追加
6. `~/.bashrc`への設定追記

---

## 5. WSL2の終了
```bash
exit
```

---

## 7. WSL2をシャットダウン
```powershell
wsl --shutdown
```

---

## 8. ベースイメージのエクスポート

エクスポート先ディレクトリを作成：
```powershell
mkdir C:\WSL -ErrorAction SilentlyContinue
```

エクスポート：
```powershell
wsl --export ubuntu-base C:\WSL\ubuntu-base.tar
```

エクスポートには数分かかります。完了後、`C:\WSL\ubuntu-base.tar`が作成されます。

---

## ベースイメージの保管

- `C:\WSL\ubuntu-base.tar`を安全な場所にバックアップ
- 定期的に更新（推奨：月1回）
- バージョン管理（例：`ubuntu-base-2024-01.tar`）

---

## ⚠️ 重要な注意事項

このベースイメージには`baseuser`という共通ユーザーが含まれています。

**プロジェクト環境作成時に必ず以下を実施してください：**
1. 個人ユーザーを作成
2. `baseuser`を削除

---

## 次のステップ

[プロジェクト環境作成手順](setup-project.md)に進んでください。