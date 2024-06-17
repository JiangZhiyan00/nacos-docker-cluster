ARG NACOS_VERSION=v2.1.0-slim
# 使用官方 Nacos 镜像作为基础
FROM nacos/nacos-server:${NACOS_VERSION}
# 更新包列表并安装 curl
RUN apt-get update && apt-get install -y curl
