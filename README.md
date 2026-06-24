# 好价分享平台

一个用于分享优惠信息的网站，包含前端展示和后台管理功能。

## 功能特性

### 前端展示
- 🎯 优惠信息展示（卡片式布局）
- 🔍 分类筛选功能
- ⭐ 推荐优惠置顶
- 💰 价格对比显示（原价/优惠价/折扣）
- 🏷️ 优惠码展示
- 📱 响应式设计

### 后台管理
- ➕ 新增优惠信息
- ✏️ 编辑优惠信息
- 🗑️ 删除优惠信息（软删除）
- 📊 优惠状态管理（有效/无效）
- ⭐ 推荐设置

## 技术栈

### 后端
- **FastAPI** - 高性能 Python Web 框架
- **SQLAlchemy** - ORM 数据库操作
- **SQLite** - 轻量级数据库

### 前端
- **Vue 3** - 渐进式 JavaScript 框架
- **Vue Router** - 路由管理
- **Axios** - HTTP 客户端
- **Vite** - 快速的前端构建工具

## 快速开始

### 环境要求
- Python 3.8+
- Node.js 16+
- npm 或 yarn

### 安装步骤

#### 1. 安装后端依赖
```bash
cd backend
pip install -r requirements.txt
```

#### 2. 安装前端依赖
```bash
cd frontend
npm install
```

### 运行项目

#### 方式一：使用启动脚本（推荐）
```bash
# Windows
start.bat
```

#### 方式二：手动启动

**启动后端：**
```bash
cd backend
uvicorn main:app --reload --port 8000
```

**启动前端：**
```bash
cd frontend
npm run dev
```

### 访问地址

- **前端页面**: http://localhost:3000
- **后台管理**: http://localhost:3000/admin
- **API 文档**: http://localhost:8000/docs

## 项目结构

```
deal_sharing/
├── backend/                # 后端项目
│   ├── main.py            # FastAPI 应用入口
│   ├── models.py          # 数据库模型
│   ├── schemas.py         # Pydantic 数据模型
│   ├── database.py        # 数据库配置
│   ├── routers/           # API 路由
│   │   ├── deals.py       # 前端展示 API
│   │   └── admin.py       # 后台管理 API
│   └── requirements.txt   # Python 依赖
├── frontend/              # 前端项目
│   ├── src/
│   │   ├── views/
│   │   │   ├── Home.vue   # 首页（优惠展示）
│   │   │   └── Admin.vue  # 后台管理页
│   │   ├── api.js         # API 接口封装
│   │   ├── router/        # 路由配置
│   │   └── App.vue        # 根组件
│   ├── package.json
│   └── vite.config.js
└── start.bat              # Windows 启动脚本
```

## API 接口

### 前端接口
- `GET /api/deals` - 获取优惠列表
- `GET /api/deals/{id}` - 获取单个优惠详情
- `GET /api/categories` - 获取所有分类

### 后台接口
- `GET /api/admin/deals` - 获取所有优惠（包括已失效）
- `POST /api/admin/deals` - 创建优惠
- `PUT /api/admin/deals/{id}` - 更新优惠
- `DELETE /api/admin/deals/{id}` - 删除优惠

## 数据库字段说明

| 字段 | 类型 | 说明 |
|------|------|------|
| title | String | 优惠标题（必填）|
| description | Text | 优惠描述 |
| original_price | Float | 原价 |
| deal_price | Float | 优惠价 |
| discount | Float | 折扣力度 |
| category | String | 分类 |
| merchant | String | 商家名称 |
| link | String | 购买链接 |
| image_url | String | 商品图片URL |
| coupon_code | String | 优惠码 |
| is_active | Boolean | 是否有效 |
| is_featured | Boolean | 是否推荐 |
| expire_at | DateTime | 过期时间 |

## 开发说明

### 后端开发
```bash
cd backend
uvicorn main:app --reload --port 8000
```

访问 http://localhost:8000/docs 查看交互式 API 文档

### 前端开发
```bash
cd frontend
npm run dev
```

支持热更新，修改代码后自动刷新

### 生产部署

**前端构建：**
```bash
cd frontend
npm run build
```

构建后的文件在 `frontend/dist` 目录

**后端部署：**
```bash
cd backend
uvicorn main:app --host 0.0.0.0 --port 8000
```

建议使用 Gunicorn + Uvicorn workers 进行生产部署

## License

MIT
