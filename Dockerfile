# Stage 1: Build Vue app
FROM node:20-alpine as build
WORKDIR /app

# Copy package files
COPY package*.json ./

# Force install devDependencies by clearing NODE_ENV
ENV NODE_ENV=development
RUN npm install

# Copy rest of app and build
COPY . .
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:stable-alpine

# Copy the built output to nginx html directory
COPY --from=build /app/dist /usr/share/nginx/html

# Copy custom nginx config for SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 and run nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
