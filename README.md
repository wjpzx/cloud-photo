# 云相册 (Cloud Photo) v1.1

基于 Django + FastDFS + MySQL + Redis 的私有云相册系统，支持图片/视频上传、文件夹管理、分享、回收站。

## v1.1 新增功能

- **文件夹管理**：创建/重命名/删除文件夹，支持嵌套层级
- **拖拽导航**：文件拖拽可在任意层级目录之间移动，悬停 800ms 自动上下探，停止即放入
- **分享功能**：文件和文件夹均支持分享，可选密码保护和有效期（1h~7天），分享页无需登录
- **回收站层级**：只显示顶层已删除项，恢复时自动连带上级链，避免文件孤立
- **全角兼容**：文件夹名、密码、手机号输入全角字符自动转半角
- **回到顶部**：右下角毛玻璃按钮，滚动 300px 后出现

## 功能特性

- 密码登录 / 短信验证码登录 / 注册
- 图片与视频拖拽上传（支持 JPG/PNG/MP4）
- 照片网格展示，右键菜单查看大图、删除、分享
- 文件夹网格 + 面包屑导航 + 拖拽移动
- **回收站**：删除文件/文件夹保留 30 天，支持恢复和彻底删除
- 短信验证码频率限制（60 秒间隔、每日上限、IP 限制）
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
│   ├── models.py           # 数据模型（User/File/Folder/Share）
│   ├── views.py            # 视图逻辑（登录/上传/删除/回收站/分享/文件夹）
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
│   ├── pic.html            # 相册主页（上传/浏览/删除/文件夹/分享/拖拽）
│   ├── recycle_bin.html    # 回收站（顶层显示+恢复上级链）
│   ├── share.html          # 公开分享页（密码验证/文件夹网格）
│   └── index.html          # 旧版首页（备用）
├── static/                 # 静态资源
│   ├── favicon.ico         # 网站图标
│   ├── lib/                # 第三方库（Bootstrap/Font Awesome/jQuery 本地化）
│   ├── css/                # 自定义样式
│   ├── js/                 # 自定义脚本
│   └── image/              # 图片资源
├── cloud-photo.service     # systemd 服务文件
├── nginx-cloud-photo.conf  # Nginx 配置
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

- 删除文件/文件夹 → 标记 `is_deleted=True`，移入回收站
- 回收站保留 **30天**
- 只显示顶层已删除项，子内容不单独列出
- 恢复时自动连带恢复上级链
- 彻底删除 → 递归删子内容 + FastDFS 文件清理

## 分享逻辑

- 支持文件和文件夹分享
- 可选密码保护（6 位以内）
- 有效期可设 1h / 24h / 3天 / 7天
- 分享页无需登录
- 文件夹分享展示文件网格，每个文件可单独下载

## 安全措施

- 短信验证码：60秒发送间隔、每日上限、IP 频率限制（防攻击）
- 登录验证装饰器 `@login_require` 保护所有敏感页面
- Session 通过 Redis 管理
- CSRF 保护
- 全角字符自动归一化，防止输入法混用导致匹配失败

## 版本标签

| 标签 | 说明 |
|------|------|
| v1.0 | 基础相册 + 回收站 |
| v1.1 | 文件夹管理 + 分享 + 拖拽导航 |

## Git

仓库地址：`git@github.com:wjpzx/cloud-photo.git`
