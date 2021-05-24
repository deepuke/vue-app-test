#Build stage
FROM node:14-alpine AS build
WORKDIR /app
COPY package*.json ./


RUN npm ci

COPY . /app

RUN npm run build

#Production stage
FROM nginx:stable-alpine AS prod
WORKDIR /app
ARG webroot="/usr/share/nginx/html/"
RUN rm /usr/share/nginx/html/index.html

COPY ./deployment/nginx.conf  /etc/nginx/cong.d/default.conf
COPY --from=build /app/dist $webroot

EXPOSE 80/tcp
EXPOSE 443/tcp

CMD ["nginx", "-g", "daemon off;"]



