FROM ubuntu:22.04 as build

RUN apt-get update && apt-get install -y \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y nginx \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /app/build /var/www/html

RUN echo 'server { \
    listen 3000; \
    server_name localhost; \
    root /var/www/html; \
    index index.html; \
    location / { \
        try_files $uri $uri/ /index.html; \
    } \
}' > /etc/nginx/sites-available/default

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]
