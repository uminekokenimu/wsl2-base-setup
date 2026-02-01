# メンテナンス

ベースイメージとプロジェクト環境のメンテナンス方法です。

## ベースイメージの更新

※月次更新（推奨）

### 1. ベースイメージに入る
```bash
wsl -d ubuntu-base -u root
```

### 2. パッケージ更新
```bash
sudo apt update
```
```bash
sudo apt upgrade -y
```

### 3. Docker更新（必要に応じて）
```bash
cd ~/wsl2-base-setup
```
```bash
git pull
```
```bash
./install-docker.sh
```

### 4. 再エクスポート
```bash
exit
```

### 5. WSL2をシャットダウン
```powershell
wsl --shutdown
```

### 6. 古いベースイメージをバックアップ
```powershell
Move-Item C:\WSL\ubuntu-base.tar C:\WSL\ubuntu-base-backup-$(Get-Date -Format 'yyyyMMdd').tar
```

### 7. 新しいベースイメージをエクスポート
```powershell
wsl --export ubuntu-base C:\WSL\ubuntu-base.tar
```

## Dockerインストール手順の更新

### 1. 公式ドキュメントが変更された場合

1. `install-docker.sh`を編集
2. 変更内容をテスト
3. コミット・プッシュ

### 2. テスト用インスタンスで確認
```bash
wsl -d ubuntu-base
```
```bash
cd ~/wsl2-base-setup
```
```bash
git pull
```
```bash
./install-docker.sh
```
```bash
docker run hello-world
```

## バージョン管理

### 1. ベースイメージに日付やバージョンを付ける
```powershell
wsl --export ubuntu-base C:\WSL\ubuntu-base-2024-01-15.tar
```

### 2. 最新版へのシンボリックリンク（PowerShell 7+）
```powershell
New-Item -ItemType SymbolicLink -Path "C:\WSL\ubuntu-base.tar" -Target "C:\WSL\ubuntu-base-2024-01-15.tar"
```

## プロジェクト環境の更新

既存のプロジェクト環境を最新のベースイメージに更新：

### 方法1: 再作成（推奨）

### 1. プロジェクトをバックアップ

```bash
wsl -d old-project
```
```bash
tar -czf ~/project-backup.tar.gz ~/your-project
```
```bash
cp ~/project-backup.tar.gz /mnt/c/backup/
```
```bash
exit
```

### 2. 古い環境を削除
```powershell
wsl --unregister old-project
```

### 3. 新しいベースから再作成
```powershell
wsl --import new-project C:\WSL\new-project C:\WSL\ubuntu-base.tar
```

### 4. プロジェクトを復元
```bash
wsl -d new-project
```
```bash
cp /mnt/c/backup/project-backup.tar.gz ~/
```
```bash
tar -xzf project-backup.tar.gz
```

### 方法2: パッケージのみ更新
```bash
wsl -d project-name
```
```bash
sudo apt update
```
```bash
sudo apt upgrade -y
```

## バックアップ戦略

### 定期バックアップ

プロジェクト環境のバックアップ：
```powershell
wsl --export project-name C:\WSL\Backups\project-name-$(Get-Date -Format 'yyyyMMdd').tar
```

### 推奨バックアップ先

- 外付けHDD
- クラウドストレージ（OneDrive、Google Driveなど）
- NAS

## クリーンアップ

### 不要な環境の削除

環境一覧を確認：
```powershell
wsl -l -v
```

削除：
```powershell
wsl --unregister old-project
```
```powershell
Remove-Item -Recurse C:\WSL\old-project
```

### 参考）古いバックアップの削除

3ヶ月以上前のバックアップを削除：
```powershell
Get-ChildItem C:\WSL\Backups\*.tar | Where-Object { $_.LastWriteTime -lt (Get-Date).AddMonths(-3) } | Remove-Item
```