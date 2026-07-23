FROM node:22-alpine AS frontend-build

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY frontend ./frontend
RUN npm run build

FROM node:22-alpine AS runtime

WORKDIR /app

COPY package*.json ./
RUN npm ci --omit=dev

COPY src ./src
COPY --from=frontend-build /app/public ./public

EXPOSE 3000
CMD ["node", "src/server.js"]
