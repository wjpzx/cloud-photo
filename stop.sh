#!/bin/bash
# 云相册项目停止脚本

PROJECT_DIR="/home/test/upload"
VENV_DIR="$PROJECT_DIR/venv"
UWSGI="$VENV_DIR/bin/uwsgi"

echo "正在停止云相册项目..."

# 1. 停止 uwsgi
echo "停止 uwsgi..."
$UWSGI --stop "$PROJECT_DIR/uwsgi.pid" 2>/dev/null || pkill -f "uwsgi.*upload"

# 2. 停止 FastDFS
echo "停止 FastDFS..."
sudo systemctl stop fdfs_storaged 2>/dev/null || sudo fdfs_storaged /etc/fdfs/storage.conf stop
sudo systemctl stop fdfs_trackerd 2>/dev/null || sudo fdfs_trackerd /etc/fdfs/tracker.conf stop

echo "停止完成！"
