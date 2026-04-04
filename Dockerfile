# ──────────────────────────────────────────────
# Vinzapinfotech — Multi-Stage Docker Build
# Stage 1: Build/Minify → Stage 2: Serve via Nginx
# ──────────────────────────────────────────────

# ── STAGE 1: Build & Minify ──
FROM node:20-alpine AS builder

WORKDIR /app

# Install minification tool
RUN npm install -g html-minifier-terser

# Copy all source files
COPY . .

# Minify HTML files into /app/dist
RUN mkdir -p dist && \
    for file in *.html; do \
      html-minifier-terser \
        --collapse-whitespace \
        --remove-comments \
        --remove-optional-tags \
        --remove-redundant-attributes \
        --minify-css true \
        --minify-js true \
        "$file" -o "dist/$file"; \
    done && \
    cp -r *.xml *.txt dist/ 2>/dev/null || true && \
    cp -r images dist/ 2>/dev/null || true && \
    cp -r assets dist/ 2>/dev/null || true && \
    echo "✅ Build complete"

# ── STAGE 2: Serve with Nginx ──
FROM nginx:1.25-alpine AS production

LABEL maintainer="Vijayendra Singh <vizz.bob@gmail.com>"
LABEL website="https://www.vinzapinfotech.com"
LABEL version="1.0"

# Remove default nginx page
RUN rm -rf /usr/share/nginx/html/*

# Copy built files from stage 1
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy nginx configuration
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost/ || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
