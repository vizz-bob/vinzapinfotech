#!/bin/bash
# ──────────────────────────────────────────────────────────
# Vinzapinfotech — Fresh Server Setup Script
# Run this on any new Ubuntu 22.04 / 24.04 server to install
# all required tools: Docker, AWS CLI, Terraform, Git, Nginx
#
# Usage:
#   chmod +x setup-new-server.sh
#   sudo ./setup-new-server.sh
# ──────────────────────────────────────────────────────────

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
cat << 'EOF'
 __   ___                       _       __
 \ \ / (_)_ _  ______ _ _ __   | |_ ___ \ \
  \ V /| | ' \|_  / _` | '_ \  | __/ _ \ > >
   \_/ |_|_||_/__/\__,_| .__/  |_|\___//_/
                        |_|
   Vinzapinfotech Server Setup Script
EOF
echo -e "${NC}"

# ── Update system ──
echo -e "${YELLOW}📦 Updating system packages...${NC}"
apt-get update -y && apt-get upgrade -y
apt-get install -y curl wget git unzip gnupg lsb-release ca-certificates jq

# ── Install Docker ──
echo -e "${YELLOW}🐳 Installing Docker...${NC}"
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com | sh
    usermod -aG docker ubuntu 2>/dev/null || true
    usermod -aG docker $USER 2>/dev/null || true
    systemctl enable docker
    systemctl start docker
    echo -e "${GREEN}✅ Docker installed: $(docker --version)${NC}"
else
    echo -e "${GREEN}✅ Docker already installed${NC}"
fi

# ── Install Docker Compose ──
echo -e "${YELLOW}🐳 Installing Docker Compose...${NC}"
if ! command -v docker-compose &> /dev/null; then
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)
    curl -SL "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}✅ Docker Compose: $(docker-compose --version)${NC}"
else
    echo -e "${GREEN}✅ Docker Compose already installed${NC}"
fi

# ── Install AWS CLI v2 ──
echo -e "${YELLOW}☁️  Installing AWS CLI...${NC}"
if ! command -v aws &> /dev/null; then
    curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    ./aws/install
    rm -rf aws awscliv2.zip
    echo -e "${GREEN}✅ AWS CLI: $(aws --version)${NC}"
else
    echo -e "${GREEN}✅ AWS CLI already installed${NC}"
fi

# ── Install Terraform ──
echo -e "${YELLOW}🏗️  Installing Terraform...${NC}"
if ! command -v terraform &> /dev/null; then
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
    apt-get update -y && apt-get install -y terraform
    echo -e "${GREEN}✅ Terraform: $(terraform --version | head -1)${NC}"
else
    echo -e "${GREEN}✅ Terraform already installed${NC}"
fi

# ── Install Nginx ──
echo -e "${YELLOW}🌐 Installing Nginx...${NC}"
if ! command -v nginx &> /dev/null; then
    apt-get install -y nginx
    systemctl enable nginx
    echo -e "${GREEN}✅ Nginx: $(nginx -v 2>&1)${NC}"
else
    echo -e "${GREEN}✅ Nginx already installed${NC}"
fi

# ── Install Node.js (for minification tools) ──
echo -e "${YELLOW}🟢 Installing Node.js...${NC}"
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs
    echo -e "${GREEN}✅ Node.js: $(node --version)${NC}"
else
    echo -e "${GREEN}✅ Node.js already installed: $(node --version)${NC}"
fi

# ── Install html-minifier-terser ──
npm install -g html-minifier-terser 2>/dev/null || true

# ── Clone the website ──
echo -e "${YELLOW}📥 Cloning Vinzapinfotech website...${NC}"
if [ ! -d "/var/www/vinzapinfotech" ]; then
    mkdir -p /var/www
    git clone https://github.com/YOUR_GITHUB_USERNAME/vinzapinfotech.git /var/www/vinzapinfotech
    echo -e "${GREEN}✅ Website cloned${NC}"
else
    cd /var/www/vinzapinfotech && git pull
    echo -e "${GREEN}✅ Website updated${NC}"
fi

# ── Configure Nginx ──
echo -e "${YELLOW}🌐 Configuring Nginx...${NC}"
cp /var/www/vinzapinfotech/nginx/nginx.conf /etc/nginx/nginx.conf
nginx -t && systemctl reload nginx
echo -e "${GREEN}✅ Nginx configured and reloaded${NC}"

# ── Set up health check cron ──
echo -e "${YELLOW}⏰ Setting up health check cron...${NC}"
chmod +x /var/www/vinzapinfotech/scripts/health-check.sh
(crontab -l 2>/dev/null; echo "*/5 * * * * /var/www/vinzapinfotech/scripts/health-check.sh >> /var/log/vinzap-health.log 2>&1") | crontab -
echo -e "${GREEN}✅ Health check scheduled every 5 minutes${NC}"

echo -e "\n${GREEN}══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  🎉 SERVER SETUP COMPLETE!                       ${NC}"
echo -e "${GREEN}══════════════════════════════════════════════════${NC}"
echo -e "\n  Next steps:"
echo -e "  1. Run: aws configure  (set your AWS keys)"
echo -e "  2. Run: cd /var/www/vinzapinfotech && ./scripts/deploy.sh"
echo -e "  3. Visit: https://www.vinzapinfotech.com"
echo -e "\n  Installed tools:"
echo -e "  • Docker: $(docker --version)"
echo -e "  • AWS CLI: $(aws --version 2>&1 | head -1)"
echo -e "  • Terraform: $(terraform --version | head -1)"
echo -e "  • Node.js: $(node --version)"
echo -e "  • Nginx: $(nginx -v 2>&1)"
