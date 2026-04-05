# 🚀 VinzapInfotech.com — IT Services & Free Tutorials Website

[![Live Site](https://img.shields.io/badge/Live%20Site-www.vinzapinfotech.com-blue?style=for-the-badge&logo=google-chrome)](https://www.vinzapinfotech.com)
[![AWS S3](https://img.shields.io/badge/Hosted%20On-AWS%20S3%20%2B%20CloudFront-orange?style=for-the-badge&logo=amazon-aws)](https://aws.amazon.com)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

> A free static website offering IT services, internship programs, and free tutorials for DevOps & Digital Marketing — in Hindi + English.

---

## 🌐 Live Website

| Page | URL |
|------|-----|
| 🏠 Homepage | https://www.vinzapinfotech.com |
| 🚀 DevOps Tutorials | https://www.vinzapinfotech.com/devops-tutorials.html |
| 📱 Digital Marketing | https://www.vinzapinfotech.com/digital-marketing.html |
| 🔒 Privacy Policy | https://www.vinzapinfotech.com/privacy-policy.html |

---

## 📁 File Structure

```
vinzapinfotech/
├── index.html                 ← Homepage
├── devops-tutorials.html      ← DevOps Tutorials (AWS, Docker, Jenkins, K8s)
├── digital-marketing.html     ← Digital Marketing (SEO, Google Ads, Social Media)
├── privacy-policy.html        ← Privacy Policy (required for AdSense)
├── sitemap.xml                ← SEO Sitemap
├── robots.txt                 ← Search engine crawl rules
└── BingSiteAuth.xml           ← Bing Webmaster verification
└── Terraform                  ← Infrastructure as Code (IaC) can recreate the setup reliably in any                                         environment.
```

---

## ✨ Features

### 🏠 Homepage (`index.html`)
- **Quick Tutorial Buttons** — DevOps, Digital Marketing, Social Media, SEO, Google Ads
- **SEO & Ranking Tools Section** — Google Trends embed, PageSpeed Insights, Gemini API, Groq API, Ubersuggest, YouTube Data API
- **Featured Videos** — 3 lazy-loaded YouTube tutorial cards
- **IT Services Grid** — Web Dev, App Dev, Cloud, DevOps, AI/ML, Cybersecurity
- **Internship Programs** — 6 programs with duration & fees
- **Enrollment Form** — Student inquiry form
- **Responsive Design** — Works on all devices

### 🚀 DevOps Tutorials (`devops-tutorials.html`)
- **7 Tabs** — DevOps | AWS | Docker | Jenkins | GitHub CI/CD | Linux | Kubernetes
- **21 YouTube Videos** — Lazy loaded (click to play)
- **Cheatsheets** — AWS CLI, Docker, Jenkins Pipeline, GitHub Actions, Linux, kubectl
- **AI Chat Widget** — DevOps Q&A in Hinglish, no API key needed
- **Enrollment Sidebar** — Free course sign-up form

### 📱 Digital Marketing Tutorials (`digital-marketing.html`)
- **7 Tabs** — Social Media | SEO | Google Ads | Meta Ads | Content | YouTube | Email
- **20+ YouTube Videos** — Lazy loaded
- **Cheatsheets** — Social Media Calendar, SEO Checklist, Google Ads formulas, Meta Ads structure
- **AI Chat Widget** — Marketing assistant in Hindi + English
- **Free Tools Sidebar** — Ubersuggest, Canva, Mailchimp, Buffer, GA4

---

## 🛠️ Tech Stack

| Technology | Usage |
|-----------|-------|
| HTML5 + CSS3 | All pages — no framework |
| Vanilla JavaScript | Tabs, lazy load, AI chat, search |
| YouTube Embed API | Lazy-loaded video thumbnails |
| Google Trends Widget | Embedded trends chart on homepage |
| Google Tag Manager | GTM-TVTBVCZH |
| Google Analytics 4 | G-HEL83H3BW4 |
| Google AdSense | ca-pub-2639020346909963 |
| AWS S3 + CloudFront | Hosting + CDN |

---

## 🚀 Deployment

### Option 1: AWS S3 + CloudFront (Current)

```
S3 Bucket:         vinzapinfotech.com (us-east-1)
CloudFront ID:     E3LBDJFANT9F4V
CloudFront Domain: dw2bcpw5sxne3.cloudfront.net
SSL Certificate:   ACM — us-east-1
```

**Steps:**
1. Upload all files to S3 bucket `vinzapinfotech.com`
2. Go to CloudFront → Distribution `E3LBDJFANT9F4V`
3. Create Invalidation → type `/*` → Submit
4. Wait 2 minutes → site is live

### Option 2: Netlify (Free — Easiest)

1. Go to [netlify.com](https://netlify.com) → Sign up free
2. Drag and drop this folder onto the deploy area
3. Add custom domain `www.vinzapinfotech.com`
4. Netlify auto-issues free SSL certificate

### Option 3: Vercel (Free)

1. Push this repo to GitHub
2. Go to [vercel.com](https://vercel.com) → Import GitHub repo
3. Deploy → Add custom domain

### Option 4: GitHub Pages (Free)

1. Go to repo Settings → Pages
2. Source: Deploy from branch → main → / (root)
3. Add custom domain `www.vinzapinfotech.com`

---

## 🌐 DNS Setup (GoDaddy)

### For AWS CloudFront:
| Type | Name | Value |
|------|------|-------|
| CNAME | www | `dw2bcpw5sxne3.cloudfront.net` |
| Forwarding | @ | `https://www.vinzapinfotech.com` (301) |

### For Netlify:
| Type | Name | Value |
|------|------|-------|
| CNAME | www | `your-site.netlify.app` |
| A | @ | `75.2.60.5` |

---

## 📊 Tracking & Monetisation

| Code | ID |
|------|----|
| Google Analytics 4 | `G-HEL83H3BW4` |
| Google Tag Manager | `GTM-TVTBVCZH` |
| Google AdSense | `ca-pub-2639020346909963` |
| Udemy Affiliate | Replace `YOUR_UDEMY_ID` in all tutorial links |

---

## 📋 Post-Deployment Checklist

- [ ] Test all 4 pages load correctly
- [ ] Test YouTube lazy load (click a video thumbnail)
- [ ] Test AI chat widget (bottom-right button)
- [ ] Test on mobile phone
- [ ] Submit sitemap to [Google Search Console](https://search.google.com/search-console)
- [ ] Verify Google Analytics is receiving data
- [ ] Publish Google Tag Manager container
- [ ] Submit site to [Google AdSense](https://adsense.google.com) for review
- [ ] Add real phone/address to `privacy-policy.html`
- [ ] Get Bing verification code and update `BingSiteAuth.xml`
- [ ] Replace `YOUR_UDEMY_ID` with real Udemy affiliate ID

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

## 🤖 AI Chat Widget

Both tutorial pages include a built-in AI chat assistant that works **without any API key**. It uses pattern matching to answer questions about DevOps and Digital Marketing in Hindi + English (Hinglish).

**DevOps topics:** docker, kubernetes, aws, jenkins, linux, ci/cd, pipeline
**Marketing topics:** seo, google ads, facebook ads, instagram, email marketing, youtube

---

## 👤 Owner

**Vijayendra Singh**
📧 vizz.bob@gmail.com
📍 Bangalore, India
🌐 [www.vinzapinfotech.com](https://www.vinzapinfotech.com)

---

## 📄 License

This project is licensed under the MIT License — feel free to use it as a template for your own website.

---

*Made with ❤️ in Bangalore, India*
