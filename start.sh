#!/bin/bash
# 云相册项目启动脚本

PROJECT_DIR="/home/test/upload"
VENV_DIR="$PROJECT_DIR/venv"
UWSGI="$VENV_DIR/bin/uwsgi"

echo "正在启动云相册项目..."

# 1. 启动 FastDFS tracker
echo "启动 FastDFS tracker..."
sudo systemctl start fdfs_trackerd 2>/dev/null || sudo fdfs_trackerd /etc/fdfs/tracker.conf start

# 2. 启动 FastDFS storage
echo "启动 FastDFS storage..."
sudo systemctl start fdfs_storaged 2>/dev/null || sudo fdfs_storaged /etc/fdfs/storage.conf start

# 3. 启动 uwsgi
echo "启动 uwsgi..."
cd "$PROJECT_DIR"
$UWSGI --ini uwsgi.ini

echo "启动完成！"
echo "访问地址: http://192.168.199.128:8000"
