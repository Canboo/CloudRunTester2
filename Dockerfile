FROM node:lts-alpine as build-stage

# 安裝 npm（Node 包管理器）和 node（Node.js）
RUN apk add --update npm

# 安裝 shadow 包，提供 groupadd 和 useradd 命令
RUN apk add --no-cache shadow

# 新增 group and user
RUN groupadd -r appuser && useradd -r -g appuser appuser

# 設定工作目錄
WORKDIR /app

# 當前目錄下的所有文件複製到工作目錄目錄
COPY . .
RUN npm install
RUN npm run build

FROM nginx:stable-alpine as production-stage

COPY ./nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=build-stage /app/dist /usr/share/nginx/html

USER appuser

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
