#!/bin/bash
# ──────────────────────────────────────────────────────────
# Vinzapinfotech — Manual Deploy Script
# Usage: ./scripts/deploy.sh [production|staging]
# ──────────────────────────────────────────────────────────

set -euo pipefail

# ── Config ──
ENVIRONMENT=${1:-production}
S3_BUCKET="vinzapinfotech.com"
CLOUDFRONT_ID="E3LBDJFANT9F4V"
AWS_REGION="us-east-1"
WEBSITE_URL="https://www.vinzapinfotech.com"

# ── Colors ──
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}  Vinzapinfotech Deploy Script              ${NC}"
echo -e "${BLUE}  Environment: ${YELLOW}$ENVIRONMENT${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"

# ── Check AWS CLI ──
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI not installed. Install: https://aws.amazon.com/cli/${NC}"
    exit 1
fi

# ── Check credentials ──
echo -e "\n${YELLOW}🔑 Checking AWS credentials...${NC}"
aws sts get-caller-identity --region $AWS_REGION > /dev/null 2>&1 || {
    echo -e "${RED}❌ AWS credentials not configured. Run: aws configure${NC}"
    exit 1
}
echo -e "${GREEN}✅ AWS credentials valid${NC}"

# ── Build step ──
echo -e "\n${YELLOW}🏗️  Building website...${NC}"
if command -v node &> /dev/null && command -v npx &> /dev/null; then
    mkdir -p build
    for file in *.html; do
        echo "  Minifying $file..."
        npx html-minifier-terser \
            --collapse-whitespace \
            --remove-comments \
            --minify-css true \
            --minify-js true \
            "$file" -o "build/$file" 2>/dev/null || cp "$file" "build/$file"
    done
    cp -r *.xml *.txt build/ 2>/dev/null || true
    cp -r images build/ 2>/dev/null || true
    cp -r assets build/ 2>/dev/null || true
    DEPLOY_DIR="build"
    echo -e "${GREEN}✅ Build complete${NC}"
else
    echo -e "${YELLOW}⚠️  Node.js not found, deploying source files directly${NC}"
    DEPLOY_DIR="."
fi

# ── Deploy HTML files (no-cache) ──
echo -e "\n${YELLOW}☁️  Uploading HTML files to S3...${NC}"
aws s3 sync $DEPLOY_DIR/ s3://$S3_BUCKET/ \
    --delete \
    --cache-control "no-cache, no-store, must-revalidate" \
    --exclude "*" \
    --include "*.html" \
    --region $AWS_REGION
echo -e "${GREEN}✅ HTML files uploaded${NC}"

# ── Deploy XML/TXT ──
echo -e "\n${YELLOW}☁️  Uploading SEO files...${NC}"
aws s3 sync $DEPLOY_DIR/ s3://$S3_BUCKET/ \
    --cache-control "public, max-age=86400" \
    --exclude "*" \
    --include "*.xml" \
    --include "*.txt" \
    --region $AWS_REGION
echo -e "${GREEN}✅ SEO files uploaded${NC}"

# ── Deploy static assets (long cache) ──
echo -e "\n${YELLOW}☁️  Uploading static assets...${NC}"
aws s3 sync $DEPLOY_DIR/ s3://$S3_BUCKET/ \
    --cache-control "public, max-age=31536000" \
    --exclude "*.html" \
    --exclude "*.xml" \
    --exclude "*.txt" \
    --exclude ".git/*" \
    --exclude "scripts/*" \
    --exclude "terraform/*" \
    --region $AWS_REGION
echo -e "${GREEN}✅ Assets uploaded${NC}"

# ── Invalidate CloudFront ──
echo -e "\n${YELLOW}⚡ Invalidating CloudFront cache...${NC}"
INVALIDATION_ID=$(aws cloudfront create-invalidation \
    --distribution-id $CLOUDFRONT_ID \
    --paths "/*" \
    --query 'Invalidation.Id' \
    --output text)
echo "  Invalidation ID: $INVALIDATION_ID"
echo "  Waiting for completion (this takes ~60 seconds)..."
aws cloudfront wait invalidation-completed \
    --distribution-id $CLOUDFRONT_ID \
    --id "$INVALIDATION_ID"
echo -e "${GREEN}✅ CloudFront cache cleared${NC}"

# ── Verify ──
echo -e "\n${YELLOW}🌐 Verifying deployment...${NC}"
sleep 5
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" $WEBSITE_URL)
if [ "$HTTP_STATUS" = "200" ]; then
    echo -e "${GREEN}✅ Site is LIVE! HTTP: $HTTP_STATUS${NC}"
else
    echo -e "${YELLOW}⚠️  Site returned HTTP: $HTTP_STATUS (may still be propagating)${NC}"
fi

# ── Ping search engines ──
echo -e "\n${YELLOW}📡 Pinging search engines...${NC}"
curl -s "https://www.google.com/ping?sitemap=${WEBSITE_URL}/sitemap.xml" > /dev/null && echo "  ✅ Google pinged"
curl -s "https://www.bing.com/ping?sitemap=${WEBSITE_URL}/sitemap.xml" > /dev/null && echo "  ✅ Bing pinged"

echo -e "\n${GREEN}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}  🎉 DEPLOYMENT COMPLETE!                  ${NC}"
echo -e "${GREEN}  URL: $WEBSITE_URL                        ${NC}"
echo -e "${GREEN}  Time: $(date)                            ${NC}"
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
