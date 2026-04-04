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
