# Stage 1 (still technically a build stage, but we use it to install everything)
FROM node:18 AS base
WORKDIR /app

# Copy only what's needed to install dependencies
COPY package.json ./
RUN npm install

# Copy the app code
COPY src ./src

# Production-ready final image
FROM node:18-alpine
WORKDIR /app

# Install only production deps
COPY package.json ./
RUN npm install --omit=dev

# Copy app from previous image
COPY --from=base /app/src ./src

EXPOSE 3000
CMD ["node", "src/index.js"]
