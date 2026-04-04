#!/bin/bash
# ──────────────────────────────────────────────────────────
# Vinzapinfotech — Health Check & Monitoring Script
# Usage: ./scripts/health-check.sh
# Schedule this in cron: */5 * * * * /path/to/health-check.sh
# ──────────────────────────────────────────────────────────

set -euo pipefail

WEBSITE_URL="https://www.vinzapinfotech.com"
PAGES=(
    "/"
    "/devops-tutorials.html"
    "/digital-marketing.html"
    "/privacy-policy.html"
    "/sitemap.xml"
    "/robots.txt"
)
ALERT_EMAIL="vizz.bob@gmail.com"
LOG_FILE="/tmp/vinzap-health.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# ── Colors ──
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

FAILED_PAGES=()
PASSED_PAGES=()

echo -e "\n${YELLOW}══════════════════════════════════════════${NC}"
echo -e "${YELLOW}  Vinzapinfotech Health Check — $TIMESTAMP${NC}"
echo -e "${YELLOW}══════════════════════════════════════════${NC}"

for page in "${PAGES[@]}"; do
    URL="${WEBSITE_URL}${page}"
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$URL" 2>/dev/null || echo "000")
    RESPONSE_TIME=$(curl -s -o /dev/null -w "%{time_total}" --max-time 10 "$URL" 2>/dev/null || echo "N/A")

    if [ "$HTTP_STATUS" = "200" ] || [ "$HTTP_STATUS" = "301" ] || [ "$HTTP_STATUS" = "302" ]; then
        echo -e "${GREEN}  ✅ $page → HTTP $HTTP_STATUS (${RESPONSE_TIME}s)${NC}"
        PASSED_PAGES+=("$page")
    else
        echo -e "${RED}  ❌ $page → HTTP $HTTP_STATUS${NC}"
        FAILED_PAGES+=("$page")
    fi
done

# ── Summary ──
echo -e "\n${YELLOW}── Summary ──${NC}"
echo -e "  Passed: ${GREEN}${#PASSED_PAGES[@]}${NC} pages"
echo -e "  Failed: ${RED}${#FAILED_PAGES[@]}${NC} pages"

# ── SSL Check ──
echo -e "\n${YELLOW}── SSL Certificate ──${NC}"
DOMAIN="www.vinzapinfotech.com"
EXPIRY=$(echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2 || echo "Unable to check")
echo -e "  SSL Expires: $EXPIRY"

# ── Log to file ──
echo "[$TIMESTAMP] Passed: ${#PASSED_PAGES[@]}, Failed: ${#FAILED_PAGES[@]}" >> $LOG_FILE

# ── Alert if failures ──
if [ ${#FAILED_PAGES[@]} -gt 0 ]; then
    echo -e "\n${RED}⚠️  ALERT: ${#FAILED_PAGES[@]} pages are down!${NC}"
    echo "Failed: ${FAILED_PAGES[*]}"
    # Uncomment to send email alert (requires mailutils):
    # echo "Pages down: ${FAILED_PAGES[*]}" | mail -s "⚠️ Vinzapinfotech is DOWN!" $ALERT_EMAIL
    exit 1
else
    echo -e "\n${GREEN}✅ All pages are UP and healthy!${NC}"
fi
