#!/bin/bash
# Nav-item 部署脚本 for ARM64 软路由 (已修复权限问题)

# ----------------------------------------------------
# 1. 变量定义 (方便日后修改)
# ----------------------------------------------------
CONTAINER_NAME="nav-item"
IMAGE_NAME="ghcr.io/sowahsun/nav-item:latest"
HOST_PORT="3001"
CONTAINER_PORT="3000"
DATA_BASE_DIR="/mnt/mmc1-4/docker_data/nav-item" # 数据持久化目录
ADMIN_USER="admin"                               # 默认管理员账号
ADMIN_PASS="000000"                              # 默认初始密码（有配置文件时会被忽略）

# ----------------------------------------------------
# 2. 停止并删除旧容器
# ----------------------------------------------------
echo "Stopping and removing existing container: $CONTAINER_NAME..."
# 使用 2>/dev/null 隐藏找不到容器时的错误信息
docker stop $CONTAINER_NAME 2>/dev/null
docker rm $CONTAINER_NAME 2>/dev/null

# ----------------------------------------------------
# 3. 运行新容器 (包含权限修复参数 --user 0:0)
# ----------------------------------------------------
echo "Deploying $CONTAINER_NAME with persistence and restart policy..."
docker run -d \
  --name $CONTAINER_NAME \
  --restart unless-stopped \
  --user 0:0 \
  -p $HOST_PORT:$CONTAINER_PORT \
  -v $DATA_BASE_DIR/database:/app/database \
  -v $DATA_BASE_DIR/uploads:/app/uploads \
  -e NODE_ENV=production \
  -e ADMIN_USERNAME=$ADMIN_USER \
  -e ADMIN_PASSWORD=$ADMIN_PASS \
  $IMAGE_NAME

echo "Deployment complete. Access at http://[Your_Router_IP]:$HOST_PORT/admin"

# ----------------------------------------------------
# 总结：此脚本通过 --user 0:0 解决了在软路由上无法写入文件的问题。
# ----------------------------------------------------
