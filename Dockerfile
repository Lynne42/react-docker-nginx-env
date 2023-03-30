FROM node:18.8.0-alpine as build

WORKDIR /frontend-app

COPY package.json package-lock.json ./
RUN npm install 
COPY . .
RUN npm run build

FROM nginx:alpine
RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories \
      && apk add --no-cache bash
COPY --from=build /frontend-app/build /usr/share/nginx/html
WORKDIR /usr/local/nginx
COPY nginx.conf /etc/nginx/conf.d

# 定义一个构建时的环境变量，用于设置 API 地址
ARG REACT_APP_SSH_PORT

# 将构建时的环境变量注入到容器中
ENV REACT_APP_SSH_PORT=$REACT_APP_SSH_PORT

# CMD ["-g","daemon off;"]
# CMD sh -c "envsubst '$REACT_APP_SSH_PORT' < /usr/share/nginx/html/index.html > /usr/share/nginx/html/index.html.tmp && mv /usr/share/nginx/html/index.html.tmp /usr/share/nginx/html/index.html && echo 'REACT_APP_SSH_PORT: $REACT_APP_SSH_PORT' && nginx -g 'daemon off;'"

CMD sh -c "sed -i 's/\$REACT_APP_SSH_PORT/'\$REACT_APP_SSH_PORT'/g' /usr/share/nginx/html/index.html && echo '<script>var ssh_port = ${REACT_APP_SSH_PORT};</script>' >> /usr/share/nginx/html/index.html && nginx -g 'daemon off;'"

# sudo docker build --build-arg REACT_APP_SSH_PORT=12345 -t react-docker-nginx-env .
# sudo docker run -p 8001:3000 react-docker-nginx-env:latest