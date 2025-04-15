# Stage 1: Build Vue app
FROM node:20-alpine as build
WORKDIR /app

# Copy files and install ALL dependencies, including devDependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the app and build it
COPY . .
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:stable-alpine

# Copy the built files to nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Optional: Custom nginx config for SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 and run nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
