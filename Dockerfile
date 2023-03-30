FROM node:18.8.0-alpine as build

WORKDIR /frontend-app
COPY package.json package-lock.json ./
RUN npm install 
COPY . .
RUN npm run build

FROM nginx:1.21.4
COPY --from=build /frontend-app/build /usr/share/nginx/html/react-docker-nginx-env
WORKDIR /usr/local/nginx
COPY nginx.conf /etc/nginx/conf.d
ENTRYPOINT ["nginx"]
CMD ["-g","daemon off;"]