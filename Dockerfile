# Stage 1: Build Vue frontend
FROM node:20-alpine as frontend-build

WORKDIR /app/frontend

# Copy frontend package files and install dependencies
COPY frontend/package*.json ./
RUN npm install

# Copy frontend source and build
COPY frontend/ ./
RUN npm run build


# Stage 2: Setup backend (Node.js API server)
FROM node:20-alpine as backend-setup

WORKDIR /app/backend

# Copy backend package files and install dependencies
COPY backend/package*.json ./
RUN npm install

# Copy backend source
COPY backend/ ./


# Stage 3: Serve frontend with Nginx and run backend via Node
FROM nginx:stable-alpine

# Copy frontend build from stage 1
COPY --from=frontend-build /app/frontend/dist /usr/share/nginx/html

# Copy custom nginx config if you have one
# (optional, only if using custom routing or proxy)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy backend from stage 2
COPY --from=backend-setup /app/backend /app/backend

# Expose frontend port (default Nginx)
EXPOSE 80

# Start both backend and Nginx using a simple process manager
# Note: Nginx runs in the background, Node runs in foreground
CMD sh -c "node /app/backend/index.js & nginx -g 'daemon off;'"
