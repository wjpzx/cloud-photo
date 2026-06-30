# 云相册 (Cloud Photo) v1.0

基于 Django + FastDFS + MySQL + Redis 的私有云相册系统，支持图片/视频上传、预览、回收站管理。

## 功能特性

- 密码登录 / 短信验证码登录 / 注册
- 图片与视频拖拽上传（支持 JPG/PNG/MP4）
- 照片网格展示，右键菜单查看大图、删除
- **回收站**：删除文件保留30天，支持恢复和彻底删除
- 短信验证码频率限制（60秒间隔、每日上限、IP限制）
- 现代化毛玻璃 UI，移动端自适应

## 技术栈

| 组件 | 版本 |
|------|------|
| Python | 3.12 |
| Django | 4.0.4 |
| MySQL | 8.0 |
| Redis | 7.0 |
| FastDFS | v6.15.5 (云端 tracker) |
| uWSGI | 2.x |
| Nginx | 1.24 |

## 目录结构

```
upload/
├── manage.py               # Django 管理入口
├── requirements.txt        # Python 依赖
├── upload/                 # Django 项目配置
│   ├── settings.py         # 配置文件（数据库/Redis/日志/短信）
│   ├── urls.py             # 根路由
│   └── wsgi.py             # WSGI 入口
├── fdfs/                   # 主应用
│   ├── models.py           # 数据模型（User/File/Category）
│   ├── views.py            # 视图逻辑（登录/上传/删除/回收站）
│   ├── urls.py             # 应用路由
│   └── migrations/         # 数据库迁移
├── utils/                  # 工具模块
│   ├── fdfs.py             # FastDFS 客户端封装
│   ├── redis.py            # Redis 操作（Session/验证码/频率限制）
│   ├── wrapper.py          # 登录验证装饰器
│   ├── yunpian.py          # 云片短信 SDK
│   └── client.conf         # FastDFS tracker 配置
├── templates/              # HTML 模板
│   ├── login.html          # 登录/注册/忘记密码
│   ├── pic.html            # 相册主页（上传/浏览/删除）
│   ├── recycle_bin.html    # 回收站
│   └── index.html          # 旧版首页（备用）
├── static/                 # 静态资源
│   ├── favicon.ico         # 网站图标
│   ├── lib/                # 第三方库（Bootstrap/Font Awesome/jQuery 本地化）
│   ├── css/                # 自定义样式
│   ├── js/                 # 自定义脚本
│   └── image/              # 图片资源
├── cloud-photo.service     # systemd 服务文件
├── nginx-cloud-photo.conf  # Nginx HTTPS 配置
├── start.sh / stop.sh      # 启停脚本
└── run.log                 # 运行日志
```

## 部署说明

### 环境要求

- Ubuntu 24.04
- MySQL 8.0（数据库 `upload_project`，root 密码见 settings.py）
- Redis 7.0（密码 `project`）
- FastDFS tracker 已部署（默认云端 `152.136.160.51:22122`）

### 安装步骤

```bash
cd /home/test/upload
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python3 manage.py migrate
```

### 启动服务

```bash
sudo systemctl restart cloud-photo   # Django (uWSGI :8000)
sudo systemctl restart nginx          # Nginx 反向代理
```

访问 `http://192.168.199.128:8000`

## 回收站逻辑

- 删除照片 → 标记 `is_deleted=True`，移入回收站
- 回收站保留 **30天**，到期后可配合定时任务彻底清除
- 支持**恢复**（取消标记）和**彻底删除**（删数据库 + FastDFS）
- 主页只展示 `is_deleted=False` 的文件

## 安全措施

- 短信验证码：60秒发送间隔、每日上限、IP 频率限制（防攻击）
- 登录验证装饰器 `@login_require` 保护所有敏感页面
- Session 通过 Redis 管理
- CSRF 保护
- 支持 Nginx HTTPS 反向代理（配置文件已提供）

## Git

仓库地址：`git@github.com:wjpzx/cloud-photo.git`
