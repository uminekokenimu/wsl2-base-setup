#!/bin/bash
set -e

echo "Installing Docker using official method..."
echo "Ref: https://docs.docker.com/engine/install/ubuntu/"

# Dockerのインストール
sudo wget -O- https://get.docker.com | sudo sh

# Dockerサービスの有効化
echo ""
echo "⚙️  Enabling Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# 現在のユーザーをdockerグループに追加
echo ""
echo "👤 Adding current user to docker group..."
sudo usermod -aG docker $USER

echo ""
echo "✅ Docker installation completed!"
echo ""
echo "⚠️  Note: You need to log out and log back in for group changes to take effect."
echo "   Or run: newgrp docker"