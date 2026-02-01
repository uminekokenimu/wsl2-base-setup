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

**重要**: このユーザーは一時的なものです。後ほど削除します。
- ユーザー名: `baseuser`（固定）
- パスワード: `baseuser`（シンプルなもの）

---

## 2. Dockerのインストールと初期設定

### 1. ホームディレクトリに移動
```bash
cd ~
```

### 2. リポジトリのクローン
```bash
git clone https://github.com/uminekokenimu/wsl2-base-setup.git
```
```bash
cd wsl2-base-setup
```
※Gitがインストールされていない場合はをインストールしてください。

### 3. セットアップスクリプトの実行
```bash
chmod +x setup.sh install-docker.sh
```
```bash
./setup.sh
```

#### スクリプトが行うこと

1. システムパッケージの更新
2. keychainのインストール（SSH Agent管理用）
3. Dockerの公式インストール
5. `/etc/wsl.conf`に[network]セクションを追加
6. `~/.bashrc`への追記用設定を保存

### 4. WSL2の終了
```bash
exit
```

## 3. 不要ユーザの削除とエクスポート

### 1. rootで起動（一時的）
```powershell
wsl -d ubuntu-base -u root
```

### 2. baseuserの削除
```bash
userdel -r baseuser
```

`-r`オプションでホームディレクトリも削除されます。

**※削除確認**
```bash
cat /etc/passwd | grep baseuser
```

何も表示されなければ削除成功です。

### 3. WSL2の終了
```bash
exit
```

### 4. WSL2をシャットダウン
```powershell
wsl --shutdown
```

## 4. ベースイメージのエクスポート

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

## 次のステップ

[プロジェクト環境作成手順](setup-project.md)に進んでください。