#!/bin/bash
# Nav-item 部署脚本 for ARM64 软路由 (已修复权限问题)

# ----------------------------------------------------
# 1. 变量定义 (方便日后修改)
# ----------------------------------------------------
CONTAINER_NAME="nav-item"
IMAGE_NAME="ghcr.io/sowahsun/nav-item:latest"
HOST_PORT="3001"
CONTAINER_PORT="3000"
DATA_BASE_DIR="/mnt/mmc1-4/docker_data/nav-item"
ADMIN_USER="admin"
ADMIN_PASS="000000" # 注意：请在登录管理面板后立即修改此密码！

# ----------------------------------------------------
# 2. 停止并删除旧容器
# ----------------------------------------------------
echo "Stopping and removing existing container: $CONTAINER_NAME..."
docker stop $CONTAINER_NAME 2>/dev/null
docker rm $CONTAINER_NAME 2>/dev/null

# ----------------------------------------------------
# 3. 运行新容器 (多架构镜像，自动选择 ARM64)
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
# 注意：部署成功后，请使用当前生效的密码登录管理后台，
# 并将其修改为一个复杂的强密码。
# ----------------------------------------------------
