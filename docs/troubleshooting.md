# トラブルシューティング

よくある問題と解決方法です。

---

## Docker関連

### Dockerが起動しない

**症状:**
```bash
docker ps
Cannot connect to the Docker daemon
```

**解決方法:**
```bash
# Dockerサービスの状態確認
sudo systemctl status docker

# 起動
sudo systemctl start docker

# 自動起動が無効になっている場合
sudo systemctl enable docker
```

### dockerグループに追加したのに権限エラー

**症状:**
```bash
docker ps
permission denied
```

**解決方法:**
```bash
# ログアウト・ログイン、または
newgrp docker

# それでもダメなら再起動
exit
wsl --shutdown
```

---

## SSH関連

### SSH Agentに鍵が追加されない

**症状:**
```bash
ssh-add -l
Error connecting to agent: No such file or directory
```

**解決方法:**
```bash
# keychainを手動起動
eval `keychain --eval --agents ssh id_ed25519`

# .bashrcの設定確認
cat ~/.bashrc | grep keychain
```

### Dev ContainerでSSH接続できない

**症状:**
```bash
git pull
Permission denied (publickey)
```

**解決方法:**

1. `.devcontainer/devcontainer.json`を確認：
```json
{
  "features": {
    "ghcr.io/devcontainers/features/sshd:1": {
      "version": "latest"
    }
  }
}
```

2. Dev Containerを再ビルド：
   - Ctrl+Shift+P
   - "Dev Containers: Rebuild Container"

3. WSL2側で鍵が読み込まれているか確認：
```bash
# WSL2で
ssh-add -l
```

---

## WSL関連

### ログイン時にrootユーザーになる

**原因:**
`/etc/wsl.conf`にデフォルトユーザーが設定されていない

**解決方法:**
```bash
# rootで実行
echo "" >> /etc/wsl.conf
echo "[user]" >> /etc/wsl.conf
echo "default = your_username" >> /etc/wsl.conf
exit

# PowerShellで
wsl --shutdown
```

### wsl.confの設定が反映されない

**解決方法:**
```powershell
# 完全にシャットダウン
wsl --shutdown

# 数秒待ってから再起動
wsl -d your-instance
```

### インポート後に設定が消える

**原因:**
ベースイメージ作成時に設定が保存されていない

**解決方法:**
ベースイメージを再作成する前に、必ず設定を保存・確認してください。

---

## パフォーマンス

### WSL2が遅い

**解決方法:**

1. メモリ制限を設定（`C:\Users\YourName\.wslconfig`）：
```ini
[wsl2]
memory=8GB
processors=4
```

2. Windowsのディスク最適化を無効化：
   - 「ドライブのプロパティ」→「ツール」→「ドライブの最適化とデフラグ」で、WSL2のドライブを無効化

3. WSL2ファイルシステムを使う：
   - `/mnt/c`ではなく`/home`配下で作業

---

## Git関連

### Git user設定が保存されない

**解決方法:**
```bash
# グローバル設定を確認
git config --global --list

# 再設定
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### CRLF警告が出る

**症状:**
```
warning: LF will be replaced by CRLF
```

**解決方法:**
```bash
# 推奨設定
git config --global core.autocrlf input
```

---

## その他

### コマンドが見つからない

**症状:**
```bash
command not found: keychain
```

**解決方法:**
```bash
# パッケージを再インストール
sudo apt update
sudo apt install -y keychain
```

### 画面の色がおかしい

**解決方法:**
```bash
# .bashrcを確認
cat ~/.bashrc

# プロンプト設定が正しいか確認
echo $PS1
```