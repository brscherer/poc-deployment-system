# Stage 1: Build dependencies
FROM node:20-alpine AS builder

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci --omit=dev

COPY . .

# Stage 2: Runtime image
FROM node:20-alpine

WORKDIR /usr/src/app

COPY --from=builder /usr/src/app ./

EXPOSE 3001
USER node

CMD ["node", "server.js"]