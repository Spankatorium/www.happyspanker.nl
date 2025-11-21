# ===== BUILDER =====
FROM node:22-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy source
COPY . .

# Build Eleventy output
RUN npx @11ty/eleventy

# ===== RUNTIME =====
FROM nginx:alpine

# Remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy built site into nginx
COPY --from=builder /app/_site /usr/share/nginx/html

EXPOSE 80
