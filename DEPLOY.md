# 好价分享网站 - 部署指南

## 📋 部署前准备

### 1. 安装 Git（如果还没有）
下载地址：https://git-scm.com/download/win

安装后重启命令行，验证：
```bash
git --version
```

### 2. 注册 GitHub 账号
访问：https://github.com
注册一个免费账号

---

## 🚀 完整部署步骤

### 第一步：上传代码到 GitHub

```bash
# 进入项目目录
cd d:\tdfpy\deal_sharing

# 初始化 Git 仓库
git init

# 添加所有文件
git add .

# 提交代码
git commit -m "初始提交：好价分享网站"

# 在 GitHub 创建新仓库
# 1. 访问 https://github.com/new
# 2. 仓库名：deal-sharing
# 3. 点击 Create repository
# 4. 复制仓库地址（类似：https://github.com/你的用户名/deal-sharing.git）

# 关联远程仓库（替换为你的仓库地址）
git remote add origin https://github.com/你的用户名/deal-sharing.git

# 推送代码
git push -u origin main
```

---

### 第二步：部署后端到 Render（免费）

1. **访问 Render**
   - 网址：https://render.com
   - 点击 "Get Started"
   - 使用 GitHub 账号登录

2. **创建 Web Service**
   - 点击 "New +" → "Web Service"
   - 选择 "Connect" 你的 deal-sharing 仓库
   - 配置如下：
     - **Name**: deal-sharing-backend
     - **Region**: 选择离你近的（如 Singapore）
     - **Branch**: main
     - **Root Directory**: 留空
     - **Runtime**: Python 3
     - **Build Command**: `pip install -r backend/requirements.txt`
     - **Start Command**: `cd backend && uvicorn main:app --host 0.0.0.0 --port $PORT`

3. **部署**
   - 点击 "Create Web Service"
   - 等待部署完成（约 2-5 分钟）
   - 复制你的后端 URL（类似：`https://deal-sharing-backend.onrender.com`）

---

### 第三步：部署前端到 Vercel（免费）

1. **修改前端 API 配置**
   
   打开 `frontend/src/api.js`，将：
   ```javascript
   const api = axios.create({
     baseURL: '/api',
     timeout: 10000
   })
   ```
   
   改为（使用你的 Render 后端 URL）：
   ```javascript
   const api = axios.create({
     baseURL: 'https://deal-sharing-backend.onrender.com/api',
     timeout: 10000
   })
   ```

2. **访问 Vercel**
   - 网址：https://vercel.com
   - 点击 "Sign Up"
   - 使用 GitHub 账号登录

3. **导入项目**
   - 点击 "Add New..." → "Project"
   - 选择 deal-sharing 仓库
   - 点击 "Import"

4. **配置**
   - **Framework Preset**: Vite
   - **Root Directory**: frontend
   - **Build Command**: `npm run build`
   - **Output Directory**: dist

5. **部署**
   - 点击 "Deploy"
   - 等待部署完成（约 1-2 分钟）
   - 你会获得一个域名（类似：`https://deal-sharing.vercel.app`）

---

## ✅ 部署完成！

现在你可以通过以下地址访问：

- **前端网站**: https://deal-sharing.vercel.app（你的实际域名）
- **后台管理**: https://deal-sharing.vercel.app/admin
- **后端 API**: https://deal-sharing-backend.onrender.com/docs

---

## 🔄 后续更新代码

每次修改代码后，推送更新：

```bash
git add .
git commit -m "更新说明"
git push
```

- Vercel 会自动重新部署前端
- Render 会自动重新部署后端

---

## 💡 优化建议

### 1. 自定义域名（可选）
- 在 Vercel 设置中添加自定义域名
- 在 Render 设置中也可以添加

### 2. 环境变量
如果后续需要配置数据库等，可以在：
- Vercel: Project Settings → Environment Variables
- Render: Environment 标签页

### 3. 性能优化
Render 免费版在 15 分钟无访问后会休眠，首次访问需要等待 30-50 秒唤醒。

---

## 🆘 常见问题

### Q: 前端请求后端报 CORS 错误？
A: 后端已配置允许所有来源，应该没问题。如还有问题，检查 `backend/main.py` 的 CORS 配置。

### Q: Render 部署失败？
A: 检查 Build Logs，常见原因：
- requirements.txt 路径不对
- Python 版本问题
- 依赖安装失败

### Q: Vercel 部署失败？
A: 检查：
- frontend/package.json 是否正确
- 构建命令是否正确
- 查看 Deployment Logs

---

## 📞 需要帮助？

如果部署过程中遇到任何问题，告诉我具体的错误信息，我会帮你解决！
