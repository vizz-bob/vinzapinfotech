# 🚀 Vinzapinfotech — Complete DevOps & CI/CD Guide

> **Owner:** Vijayendra Singh | **Website:** https://www.vinzapinfotech.com
> **Last Updated:** April 2026

---

## 📋 Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Files Created](#files-created)
3. [GitHub Actions CI/CD Setup](#github-actions-cicd-setup)
4. [Docker — Local Development](#docker--local-development)
5. [Terraform — Infrastructure as Code](#terraform--infrastructure-as-code)
6. [Deploy to Another Server](#deploy-to-another-server)
7. [Monitoring & Health Checks](#monitoring--health-checks)
8. [Troubleshooting](#troubleshooting)
9. [Quick Reference Commands](#quick-reference-commands)

---

## 🏗️ Architecture Overview

```
                         ┌─────────────────────────────────┐
                         │          DEVELOPER               │
                         │   (git push to GitHub main)      │
                         └──────────────┬──────────────────┘
                                        │
                                        ▼
                         ┌─────────────────────────────────┐
                         │       GITHUB ACTIONS CI/CD       │
                         │                                  │
                         │  1. Lint HTML files              │
                         │  2. Security scan (Gitleaks)     │
                         │  3. Build & minify HTML          │
                         │  4. Deploy to S3                 │
                         │  5. Invalidate CloudFront        │
                         │  6. Ping Google/Bing sitemap     │
                         └──────────────┬──────────────────┘
                                        │
                                        ▼
          ┌────────────────────────────────────────────────────┐
          │                     AWS CLOUD                       │
          │                                                     │
          │   ┌──────────┐     ┌──────────────┐     ┌───────┐  │
          │   │   S3     │────▶│  CloudFront  │────▶│  ACM  │  │
          │   │ (Files)  │     │   (CDN+SSL)  │     │  SSL  │  │
          │   └──────────┘     └──────────────┘     └───────┘  │
          │                           │                         │
          │                    ┌──────────────┐                 │
          │                    │   Route53    │                 │
          │                    │    (DNS)     │                 │
          │                    └──────────────┘                 │
          └────────────────────────────────────────────────────┘
                                        │
                                        ▼
                         ┌─────────────────────────────────┐
                         │           USERS WORLDWIDE        │
                         │    https://www.vinzapinfotech.com│
                         └─────────────────────────────────┘
```

---

## 📁 Files Created

```
vinzapinfotech/
├── .github/
│   └── workflows/
│       ├── deploy.yml          ← Main CI/CD pipeline (build + test + deploy)
│       └── lighthouse.yml      ← Weekly performance audit
├── terraform/
│   ├── main.tf                 ← All AWS resources (S3, CloudFront, SSL, DNS)
│   ├── variables.tf            ← Input variables
│   ├── outputs.tf              ← Output values after apply
│   └── terraform.tfvars.example← Fill this with your values
├── nginx/
│   └── nginx.conf              ← Production Nginx config (gzip, security headers)
├── scripts/
│   ├── deploy.sh               ← Manual deploy to S3 + CloudFront
│   ├── health-check.sh         ← Check all pages are up
│   └── setup-new-server.sh     ← Install everything on a fresh server
├── Dockerfile                  ← Multi-stage Docker build
├── docker-compose.yml          ← Local dev + production
├── .dockerignore               ← Exclude unnecessary files from Docker
├── .gitignore                  ← Exclude secrets and build files
├── DEVOPS_CICD_GUIDE.md        ← This file
└── PROMOTION_MONETIZATION.md   ← Growth and earning strategies
```

---

## ⚙️ GitHub Actions CI/CD Setup

### Step 1: Push your code to GitHub

```bash
cd /path/to/vinzapinfotech

# If not already a git repo:
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/vinzapinfotech.git
git push -u origin main
```

### Step 2: Create an AWS IAM User for GitHub Actions

1. Go to **AWS Console → IAM → Users → Create User**
2. Username: `github-actions-vinzap`
3. Attach these policies:
   - `AmazonS3FullAccess` (or scoped to your bucket only)
   - `CloudFrontFullAccess`
4. Create **Access Keys** → Download them

### Step 3: Add Secrets to GitHub

Go to your GitHub repo → **Settings → Secrets and variables → Actions** → New repository secret:

| Secret Name | Value |
|---|---|
| `AWS_ACCESS_KEY_ID` | From IAM user above |
| `AWS_SECRET_ACCESS_KEY` | From IAM user above |

### Step 4: Update the workflow with your values

Edit `.github/workflows/deploy.yml` — update these lines:

```yaml
env:
  S3_BUCKET: vinzapinfotech.com        # ← Your S3 bucket name
  CLOUDFRONT_DISTRIBUTION_ID: E3LBDJFANT9F4V  # ← Your CloudFront ID
  AWS_REGION: us-east-1
```

### Step 5: How CI/CD works

Every time you `git push` to `main`:

```
Push to main
    ↓
Job 1: Lint HTML + check links (parallel)
Job 2: Security scan with Gitleaks (parallel)
    ↓
Job 3: Build — minify HTML/CSS/JS
    ↓
Job 4: Deploy to S3 + invalidate CloudFront (only on main push)
    ↓
Job 5: Ping Google & Bing sitemaps
```

Pull requests only run lint + security (no deploy) — safe to test.

### Step 6: Trigger manually

Go to GitHub → **Actions → 🚀 Vinzap CI/CD → Run workflow → Run**

---

## 🐳 Docker — Local Development

### Run locally with Docker

```bash
cd vinzapinfotech

# Build and run
docker build -t vinzapinfotech .
docker run -d -p 80:80 --name vinzap_web vinzapinfotech

# Open in browser
open http://localhost
```

### Run with Docker Compose (recommended)

```bash
# Production mode (Nginx serving minified files)
docker-compose up -d

# Dev mode with live reload at localhost:3000
docker-compose --profile dev up

# Check running containers
docker ps

# View logs
docker-compose logs -f web

# Stop
docker-compose down
```

### Rebuild after changes

```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

---

## 🏗️ Terraform — Infrastructure as Code

> Use this to recreate your entire AWS infrastructure on a fresh account.

### Prerequisites

```bash
# Install Terraform (Mac)
brew install terraform

# Install Terraform (Linux)
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

### Setup

```bash
cd vinzapinfotech/terraform

# Copy and fill in your values
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars

# Set AWS credentials (do NOT put keys in tfvars)
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"
```

### Deploy infrastructure

```bash
# 1. Initialize (downloads AWS provider)
terraform init

# 2. Preview what will be created
terraform plan

# 3. Create everything (type 'yes' to confirm)
terraform apply

# 4. See outputs (CloudFront ID, S3 bucket, etc.)
terraform output
```

### What Terraform creates

| Resource | Name |
|---|---|
| S3 Bucket | `vinzapinfotech.com` (versioned, encrypted) |
| CloudFront CDN | With HTTP→HTTPS redirect, HTTP/2+3 |
| ACM SSL Certificate | For domain + www subdomain |
| Route53 DNS records | A records → CloudFront |
| CloudWatch Alarm | Alert on 4xx errors > 5% |

### Destroy infrastructure (careful!)

```bash
terraform destroy
# Type 'yes' to confirm
```

---

## 🖥️ Deploy to Another Server

### Option A: AWS EC2 (Ubuntu) — Complete setup

**1. Launch an EC2 instance:**
- AMI: Ubuntu 22.04 LTS
- Instance type: t3.micro (free tier) or t3.small
- Security group: Allow port 22 (SSH), 80 (HTTP), 443 (HTTPS)
- Key pair: Download .pem file

**2. Connect and set up:**

```bash
# Connect to your EC2
ssh -i Vinzap1.pem ubuntu@YOUR_EC2_IP

# Run the automated setup script
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/vinzapinfotech/main/scripts/setup-new-server.sh | sudo bash
```

**3. Configure AWS credentials on server:**

```bash
aws configure
# Enter your AWS_ACCESS_KEY_ID
# Enter your AWS_SECRET_ACCESS_KEY
# Region: us-east-1
# Output format: json
```

**4. Deploy:**

```bash
cd /var/www/vinzapinfotech
./scripts/deploy.sh
```

---

### Option B: Any Ubuntu VPS (DigitalOcean, Linode, Vultr, etc.)

Same steps as EC2 above — just SSH into your VPS instead.

---

### Option C: Docker on Any Server

```bash
# On new server — install Docker
curl -fsSL https://get.docker.com | sh

# Clone the repo
git clone https://github.com/YOUR_USERNAME/vinzapinfotech.git
cd vinzapinfotech

# Run with Docker
docker-compose up -d

# Done! Site at http://YOUR_SERVER_IP
```

---

### Option D: Netlify (Free — Zero Server Required)

1. Go to https://netlify.com → Sign Up (free)
2. Click **Add new site → Import from Git**
3. Connect GitHub → Select `vinzapinfotech` repo
4. Build settings:
   - Build command: (leave empty — static site)
   - Publish directory: `.`
5. Click **Deploy site**
6. Go to **Site settings → Domain → Add custom domain** → `www.vinzapinfotech.com`
7. Update your DNS CNAME to point to the netlify URL

**Netlify CI/CD is automatic** — every push to main auto-deploys!

---

### Option E: Vercel (Free)

```bash
npm install -g vercel
cd vinzapinfotech
vercel --prod
```

Then add your custom domain in Vercel dashboard.

---

## 📊 Monitoring & Health Checks

### Manual health check

```bash
./scripts/health-check.sh
```

### Schedule automatic health checks (cron)

```bash
# Check every 5 minutes
crontab -e

# Add this line:
*/5 * * * * /var/www/vinzapinfotech/scripts/health-check.sh >> /var/log/vinzap-health.log 2>&1
```

### Free uptime monitoring tools

| Tool | Free Tier | Setup |
|---|---|---|
| **UptimeRobot** | 50 monitors, 5-min interval | https://uptimerobot.com |
| **Better Uptime** | 10 monitors | https://betterstack.com |
| **Freshping** | 50 monitors, 1-min interval | https://freshping.io |
| **StatusCake** | Unlimited, 5-min | https://statuscake.com |

**Recommended:** Sign up for UptimeRobot (free). Add these URLs:
- `https://www.vinzapinfotech.com`
- `https://www.vinzapinfotech.com/devops-tutorials.html`
- `https://www.vinzapinfotech.com/digital-marketing.html`

Get SMS/email alerts when site goes down.

### Weekly Lighthouse audit

The `lighthouse.yml` workflow runs every Monday at 6 AM automatically.
Check results in GitHub → Actions → Lighthouse Performance Audit.

---

## 🔧 Troubleshooting

### Site not updating after deploy

```bash
# Manually invalidate CloudFront
aws cloudfront create-invalidation \
  --distribution-id E3LBDJFANT9F4V \
  --paths "/*"
```

### GitHub Actions failing — credentials error

```
Error: The security token included in the request is invalid
```
→ Check your `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` secrets in GitHub.

### Docker container not starting

```bash
docker logs vinzap_web
docker-compose logs web
```

### Nginx config error

```bash
nginx -t    # Test config
nginx -s reload  # Reload config
```

### Terraform "bucket already exists" error

Your S3 bucket already exists. Import it:
```bash
terraform import aws_s3_bucket.website vinzapinfotech.com
```

### Site is slow

1. Check CloudFront cache hit rate in AWS Console
2. Run Lighthouse: https://pagespeed.web.dev/?url=vinzapinfotech.com
3. Compress images: https://squoosh.app
4. Check GTMetrix: https://gtmetrix.com

---

## ⚡ Quick Reference Commands

```bash
# ── DEPLOY ──
./scripts/deploy.sh                     # Manual deploy
git push origin main                    # Trigger CI/CD auto-deploy

# ── DOCKER ──
docker-compose up -d                    # Start
docker-compose down                     # Stop
docker-compose logs -f                  # Logs

# ── HEALTH ──
./scripts/health-check.sh              # Check all pages

# ── AWS CLI ──
aws s3 ls s3://vinzapinfotech.com/      # List S3 files
aws cloudfront create-invalidation \
  --distribution-id E3LBDJFANT9F4V \
  --paths "/*"                         # Clear cache

# ── TERRAFORM ──
terraform init && terraform plan        # Preview changes
terraform apply                         # Apply
terraform output                        # See outputs
terraform destroy                       # Delete all (careful!)

# ── GIT ──
git status                              # Check changes
git add . && git commit -m "Update"    # Commit
git push origin main                   # Push + auto-deploy
```

---

## 🔒 Security Best Practices

1. **Never commit** `*.pem`, `.env`, `terraform.tfvars` — all in `.gitignore`
2. **Rotate AWS keys** every 90 days
3. **Use IAM roles** with minimum required permissions
4. **Enable MFA** on your AWS root account
5. **Enable S3 versioning** — protects against accidental deletes
6. **CloudFront WAF** — add when you get 10k+ visits/month

---

*Made with ❤️ by Vijayendra Singh — Vinzapinfotech.com*
