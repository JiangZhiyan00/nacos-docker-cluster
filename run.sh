#!/bin/bash

# 控制台颜色
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'


# 项目名称
PROJECT_NAME='nacos-cluster'

# 开始时间
start_time=$(date +%s)

echo -e "${BLUE}$(date +"%Y-%m-%d %H:%M:%S"):nacos-cluster build start......${NC}"

# 网络代理
HTTP_PROXY=$(env | grep -i '^http_proxy' | awk -F '=' '{print $2}')
HTTPS_PROXY=$(env | grep -i '^https_proxy' | awk -F '=' '{print $2}')

if [ -n "$HTTP_PROXY" ]; then
    # HTTP代理设置
    export http_proxy="$HTTP_PROXY"
    echo -e "${GREEN}HTTP_PROXY: $HTTP_PROXY${NC}"
fi
if [ -n "$HTTPS_PROXY" ]; then
    # HTTPS代理设置
    export https_proxy="$HTTPS_PROXY"
    echo -e "${GREEN}HTTPS_PROXY: $HTTPS_PROXY${NC}"
fi

echo -e "${GREEN}command:${NC} ${BLUE}sudo env COMPOSE_DOCKER_CLI_BUILD=1 HTTP_PROXY=\"$HTTP_PROXY\" HTTPS_PROXY=\"$HTTPS_PROXY\" docker-compose -p ${PROJECT_NAME} build --parallel && sudo docker-compose -p ${PROJECT_NAME} up -d${NC}"

# docker-compose构建并启动
if sudo env COMPOSE_DOCKER_CLI_BUILD=1 HTTP_PROXY="$HTTP_PROXY" HTTPS_PROXY="$HTTPS_PROXY" docker-compose -p ${PROJECT_NAME} build --parallel && sudo docker-compose -p ${PROJECT_NAME} up -d; then
  # 未使用的虚悬镜像删除
  sudo docker image prune -f --filter "dangling=true"
  echo -e "${GREEN}$(date +"%Y-%m-%d %H:%M:%S"): Docker Container(${PROJECT_NAME}) running success!${NC}"
else
  echo -e "${RED}$(date +"%Y-%m-%d %H:%M:%S"): Docker Container(${PROJECT_NAME}) running fail!${NC}"
fi

echo -e "${GREEN}command execution spent time: $(( $(date +%s) - start_time )) seconds.${NC}"
