#!/bin/bash
# ============================================================
# Vinzap Infotech — EC2 First-Time Server Setup Script
# Run this ONCE on your EC2 instance (3.225.142.65) to
# prepare it for automated Docker deployments via GitHub Actions.
#
# Usage:
#   ssh -i Vinzap1.pem ubuntu@3.225.142.65
#   curl -s https://raw.githubusercontent.com/vizz-bob/vinzapinfotech/main/scripts/setup-ec2.sh | bash
#
# Or copy this file to the server and run:
#   chmod +x setup-ec2.sh && sudo bash setup-ec2.sh
# ============================================================

set -e

echo "============================================"
echo "  Vinzap Infotech — EC2 Setup Script"
echo "  Server: 3.225.142.65"
echo "  Site:   vinzapinfotech.com"
echo "============================================"
echo ""

# ── 1. Update system ──
echo "📦 Updating system packages..."
sudo apt-get update -qq
sudo apt-get upgrade -y -qq
echo "✅ System updated"

# ── 2. Install Docker ──
echo ""
echo "🐳 Installing Docker..."
if command -v docker &> /dev/null; then
  echo "  Docker already installed: $(docker --version)"
else
  sudo apt-get install -y docker.io
  sudo systemctl start docker
  sudo systemctl enable docker
  echo "✅ Docker installed: $(docker --version)"
fi

# ── 3. Add ubuntu user to docker group ──
echo ""
echo "👤 Adding ubuntu user to docker group..."
sudo usermod -aG docker ubuntu
echo "✅ Done (re-login or run 'newgrp docker' to apply)"

# ── 4. Install Docker Compose (v2 plugin) ──
echo ""
echo "🔧 Installing Docker Compose..."
if docker compose version &> /dev/null 2>&1; then
  echo "  Docker Compose already installed: $(docker compose version)"
else
  sudo apt-get install -y docker-compose-plugin
  echo "✅ Docker Compose installed"
fi

# ── 5. Open firewall ports (ufw) ──
echo ""
echo "🔥 Configuring firewall..."
if command -v ufw &> /dev/null; then
  sudo ufw allow 22/tcp   comment "SSH"
  sudo ufw allow 80/tcp   comment "HTTP"
  sudo ufw allow 443/tcp  comment "HTTPS"
  sudo ufw --force enable
  sudo ufw status
  echo "✅ Firewall configured"
else
  echo "  ufw not found — configure Security Groups in AWS Console instead"
fi

# ── 6. Pull the Docker image for the first time ──
echo ""
echo "📥 Pulling Vinzap website Docker image..."
sudo docker pull vinzapinfotech/website:latest || {
  echo "⚠️  Could not pull image (it may not exist yet — push from GitHub Actions first)"
}

# ── 7. Start the container ──
echo ""
echo "🚀 Starting Vinzap web container..."
sudo docker stop vinzap_web 2>/dev/null || true
sudo docker rm   vinzap_web 2>/dev/null || true

if sudo docker image inspect vinzapinfotech/website:latest &>/dev/null; then
  sudo docker run -d \
    --name vinzap_web \
    --restart unless-stopped \
    -p 80:80 \
    vinzapinfotech/website:latest
  echo "✅ Container started"
  sudo docker ps --filter name=vinzap_web
else
  echo "⚠️  Image not available yet — container will start on first GitHub Actions deploy"
fi

# ── 8. Verify HTTP response ──
echo ""
echo "🌐 Testing local HTTP response..."
sleep 3
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost/ || echo "Not responding yet — check after push"

# ── 9. Print GitHub Actions secrets summary ──
echo ""
echo "============================================"
echo "  ✅ EC2 SETUP COMPLETE!"
echo "============================================"
echo ""
echo "📋 Add these secrets to GitHub:"
echo "   Repo → Settings → Secrets → Actions → New repository secret"
echo ""
echo "   EC2_SSH_KEY    → paste the full contents of Vinzap1.pem"
echo "   AWS_ACCESS_KEY_ID     → from your IAM user"
echo "   AWS_SECRET_ACCESS_KEY → from your IAM user"
echo "   DOCKER_USERNAME       → your Docker Hub username"
echo "   DOCKER_PASSWORD       → your Docker Hub password"
echo "   INDEXNOW_KEY          → get free key at indexnow.org (optional)"
echo ""
echo "ℹ️  EC2_HOST and EC2_USERNAME are already hardcoded in deploy.yml:"
echo "   EC2_HOST:     3.225.142.65"
echo "   EC2_USERNAME: ubuntu"
echo ""
echo "🚀 Once secrets are added, push to 'main' branch to trigger deployment!"
echo ""
