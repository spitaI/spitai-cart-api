# Base
FROM node:12-alpine AS base
LABEL Name="spitai-cart-api-base"
LABEL Version="1.0.0"

WORKDIR /app

# Dependencies
COPY package*.json ./
RUN npm ci && npm cache clean --force

# Build
COPY . .
RUN npm run build
RUN npm prune --production

# Application
FROM node:12-alpine

COPY --from=base /app/node_modules ./node_modules
COPY --from=base /app/dist ./dist

USER node
ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/main.js"]