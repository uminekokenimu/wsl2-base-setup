# プロジェクト環境作成手順

ベースイメージから新しいプロジェクト環境を作成する手順です。

## 前提条件

- ベースイメージ（`ubuntu-base.tar`）が作成済み

以下は読み替えてください。

- `project-name`: 任意のプロジェクト名
- `yourname`: 任意のユーザ名

---

## 1. ベースイメージからインポート
```powershell
wsl --import project-name C:\WSL\project-name C:\WSL\ubuntu-base.tar
```

## 2. rootでWSL2を起動して個人ユーザーを作成

### 1. rootで起動（一時的）
```powershell
wsl -d project-name -u root
```

### 2. 新しいユーザーを作成
```bash
adduser yourname
```

**パスワードは強固なものを設定してください：**
- 12文字以上
- 大文字・小文字・数字・記号を含む
- 推測されにくいもの

その他の情報（Full Name等）は任意で入力またはEnterでスキップ。

### 3. sudo権限を付与
```bash
usermod -aG sudo yourname
```

### 4. dockerグループに追加
```bash
usermod -aG docker yourname
```

## 3. 新ユーザーをデフォルトに設定

### 1. WSL設定ファイル開く
```bash
nano /etc/wsl.conf
```

### 2. `[user]`セクションを以下のように設定
```ini
[user]
default = yourname
```
### 3. ホスト名変更（オプション）

#### 1. /etc/wsl.confを編集
```bash
sudo nano /etc/wsl.conf
```

#### 2. `[network]`セクションのhostnameを変更
```ini
[network]
hostname = project-name
```

### 4. 保存して終了

（Ctrl+O, Enter）→（Ctrl+X）

### 5. rootを終了
```bash
exit
```

## 4. .bashrc の設定

### 1. ベースイメージに含まれているファイルで設定を追加
```bash
cat /tmp/wsl2-setup/bashrc.append >> ~/.bashrc
```

### 2. 設定を反映
```bash
source ~/.bashrc
```

## 5. 再起動して確認

### 1. シャットダウンと起動
```powershell
wsl --shutdown
```
```powershell
wsl -d project-name
```

### 2. ログイン時のパス確認

ユーザのホームディレクトリになっているか確認
```bash
yourname@project-name:~$
```

違う場合は[4](#4-bashrc-の設定)が反映されているか再確認してください。

### 3. ユーザー確認
```bash
whoami
```

→ `yourname`が表示されればOK

## 6. SSH鍵の準備

### 1. 以下の A か B いずれかを実施

#### A. 既存の鍵を使う場合

1. sshディレクトリ作成
    ```bash
    mkdir -p ~/.ssh
    ```
    ```bash
    chmod 700 ~/.ssh
    ```

2. 鍵をコピー（パスは実際のものに変更）
    ```bash
    cp /mnt/c/path/to/your_key ~/.ssh/
    ```
    ```bash
    chmod 600 ~/.ssh/your_key
    ```

3. 公開鍵もコピーする場合
    ```bash
    cp /mnt/c/path/to/your_key.pub ~/.ssh/
    ```
    ```bash
    chmod 644 ~/.ssh/your_key.pub
    ```

#### B. 新規に鍵を作成する場合

1. 鍵の作成

    **ed25519形式（推奨）:**
    ```bash
    ssh-keygen -t ed25519 -C "your@email.com"
    ```

    **RSA形式:**
    ```bash
    ssh-keygen -t rsa -b 4096 -C "your@email.com"
    ```

    デフォルトの保存場所とファイル名で良ければEnterを押します。  
    パスフレーズは任意で設定できます（推奨）。

2. 公開鍵を表示
    ```bash
    cat ~/.ssh/id_ed25519.pub
    ```

    RSA形式の場合：
    ```bash
    cat ~/.ssh/id_rsa.pub
    ```

3. この公開鍵をGitHub/GitLab等に登録

## 7. keychainの有効化

### 1. .bashrcを編集
```bash
nano ~/.bashrc
```

### 2. 以下の行を探してコメント（`#`）を外し、鍵の種類に応じて変更
```bash
# ed25519の場合（デフォルト）
eval `keychain --eval --agents ssh id_ed25519`

# RSAの場合
eval `keychain --eval --agents ssh id_rsa`

# カスタム鍵名の場合
eval `keychain --eval --agents ssh your_key_name`
```

### 3. 保存して終了

（Ctrl+O, Enter）→（Ctrl+X）

### 4. 設定を反映
```bash
source ~/.bashrc
```

パスフレーズを入力します（鍵にパスフレーズを設定している場合）。

### 5. SSH接続を確認
```bash
ssh -T git@github.com
```

## 8. Git設定

### 1. 名前とメールアドレスを設定
```bash
git config --global user.name "Your Name"
```
```bash
git config --global user.email "your@email.com"
```

### 2. 確認
```bash
git config --global --list
```

## 9. プロジェクトのクローン（オプション）

### 1. クローンと移動
```bash
git clone git@github.com:your-org/project-name.git
```
```bash
cd project-name
```

### 2. VSCodeで開く
```bash
code .
```

### 3. VSCodeで「Dev Containers: Reopen in Container」を実行

---

## Dev Container設定例

**下記のfeaturesの設定が必須**

`.devcontainer/devcontainer.json`
```json
{
  "name": "Project Dev Environment",
  "image": "mcr.microsoft.com/devcontainers/typescript-node:20",
  
  "features": {
    "ghcr.io/devcontainers/features/git:1": {},
    "ghcr.io/devcontainers/features/sshd:1": {
      "version": "latest"
    }
  },
  "postCreateCommand": "npm install",
  "forwardPorts": [3000]
}
```

---

### Dev Containerの確認事項

SSH接続が動作する：
```bash
ssh -T git@github.com
```

Git操作が動作する：
```bash
git pull
```

- [ ] Dev Containerが起動する
- [ ] Dev Container内でgit操作ができる

---

### チェックリスト

- [ ] 個人ユーザーを作成した
- [ ] 強固なパスワードを設定した
- [ ] sudo権限を付与した
- [ ] dockerグループに追加した
- [ ] デフォルトユーザーを変更した
- [ ] SSH鍵を設定した
- [ ] Git設定を完了した

---

## 環境削除

不要になった環境の削除：
```powershell
wsl --unregister project-name
```
```powershell
Remove-Item -Recurse C:\WSL\project-name
```