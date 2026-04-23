# ============================================
# Stage 1: Build Flutter Web App
# ============================================
FROM ghcr.io/cirruslabs/flutter:stable AS build

# Set working directory
WORKDIR /app

# Copy pubspec files first for better caching
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN flutter pub get

# Copy all source code
COPY . .

# Build Flutter web with optimizations
RUN flutter build web --release \
    --web-renderer canvaskit \
    --tree-shake-icons

# ============================================
# Stage 2: Serve with Nginx
# ============================================
FROM nginx:alpine

# Install envsubst to substitute $PORT at runtime
RUN apk add --no-cache gettext

# Copy built web app from build stage
COPY --from=build /app/build/web /usr/share/nginx/html

# Copy nginx config as template (uses $PORT variable)
COPY nginx.conf /etc/nginx/nginx.conf.template

# Expose default port
EXPOSE 8080

# Substitute $PORT then start nginx
CMD ["/bin/sh", "-c", "envsubst '${PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && nginx -g 'daemon off;'"]
