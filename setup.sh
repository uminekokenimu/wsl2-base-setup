#!/bin/bash
set -e

echo "========================================"
echo "WSL2 Base Image Setup"
echo "========================================"

# システム更新
echo ""
echo "📦 Updating system packages..."
sudo apt update
sudo apt upgrade -y

# keychainのインストール（SSH Agent管理用）
echo ""
echo "🔧 Installing keychain..."
sudo apt install -y keychain

# Dockerのインストール
echo ""
echo "🐋 Installing Docker..."
./install-docker.sh

# wsl.confの設定
echo ""
echo "📝 Configuring /etc/wsl.conf..."

# 既存のwsl.confをバックアップ
if [ -f /etc/wsl.conf ]; then
    sudo cp /etc/wsl.conf /etc/wsl.conf.backup.$(date +%Y%m%d_%H%M%S)
    echo "✅ Backed up existing /etc/wsl.conf"
fi

# [network] セクションがなければ追加
if ! sudo grep -q "^\[network\]" /etc/wsl.conf 2>/dev/null; then
    echo "" | sudo tee -a /etc/wsl.conf
    echo "# WSL2 Base Setup - Network Configuration" | sudo tee -a /etc/wsl.conf
    echo "[network]" | sudo tee -a /etc/wsl.conf
    echo "hostname = ubuntu-base" | sudo tee -a /etc/wsl.conf
    echo "generateHosts = true" | sudo tee -a /etc/wsl.conf
    echo "generateResolvConf = true" | sudo tee -a /etc/wsl.conf
    echo "✅ Added [network] section"
else
    echo "ℹ️  [network] section already exists, skipping..."
fi

# bashrc設定のテンプレートを保存（新ユーザーが使用）
echo ""
echo "📝 Creating bashrc configuration template..."
mkdir -p /var/tmp/wsl2-setup
cat > /var/tmp/wsl2-setup/bashrc.append << 'EOF'

# ========================================
# WSL2 Base Setup Configuration
# ========================================

# Login shell: cd to home if not already there
if shopt -q login_shell && [ "$PWD" != "$HOME" ]; then
    cd ~
fi

# SSH Agent with keychain
# 各自でSSH鍵を配置後、以下の行のコメントを外してください
# eval `keychain --eval --agents ssh id_ed25519`
EOF

echo "✅ Template saved to /tmp/wsl2-setup/bashrc.append"

echo ""
echo "========================================"
echo "✅ Setup completed!"
echo "========================================"
echo ""