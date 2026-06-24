@echo off
chcp 65001 >nul
echo ========================================
echo 好价分享网站 - Git 初始化和上传脚本
echo ========================================
echo.

cd /d d:\tdfpy\deal_sharing

REM 设置 Git 路径（常见的安装路径）
set GIT_PATH=C:\Program Files\Git\cmd\git.exe

REM 检查 Git 是否存在
if not exist "%GIT_PATH%" (
    set GIT_PATH=C:\Program Files\Git\bin\git.exe
)

if not exist "%GIT_PATH%" (
    set GIT_PATH=D:\Program Files\Git\cmd\git.exe
)

if not exist "%GIT_PATH%" (
    set GIT_PATH=D:\Program Files\Git\bin\git.exe
)

if not exist "%GIT_PATH%" (
    echo ❌ 找不到 Git！
    echo.
    echo 请确认 Git 已安装到以下位置之一：
    echo - C:\Program Files\Git\
    echo - D:\Program Files\Git\
    echo.
    echo 如果没有安装，请访问：https://git-scm.com/download/win
    echo 下载并安装 Git
    echo.
    pause
    exit /b 1
)

echo [1/6] 检查 Git...
"%GIT_PATH%" --version
echo ✓ Git 已找到

echo.
echo [2/6] 配置 Git 用户信息...
echo.
set /p gitname="请输入你的名字（用于 Git 提交）: "
set /p gitemail="请输入你的邮箱: "

"%GIT_PATH%" config --global user.name "%gitname%"
"%GIT_PATH%" config --global user.email "%gitemail%"
echo ✓ Git 配置完成

echo.
echo [3/6] 初始化 Git 仓库...
"%GIT_PATH%" init
echo ✓ 仓库初始化完成

echo.
echo [4/6] 添加文件...
"%GIT_PATH%" add .
echo ✓ 文件添加完成

echo.
echo [5/6] 提交代码...
"%GIT_PATH%" commit -m "初始提交：好价分享网站"
echo ✓ 代码提交完成

echo.
echo ========================================
echo [6/6] 推送到 GitHub
echo ========================================
echo.
echo 请先在 GitHub 创建仓库：
echo 1. 访问 https://github.com/new
echo 2. 仓库名填写：deal-sharing
echo 3. 点击 Create repository
echo 4. 复制仓库地址（类似 https://github.com/用户名/deal-sharing.git）
echo.
set /p repo_url="粘贴你的 GitHub 仓库地址: "

"%GIT_PATH%" remote add origin %repo_url%
"%GIT_PATH%" branch -M main
"%GIT_PATH%" push -u origin main

echo.
echo ========================================
echo 🎉 完成！代码已上传到 GitHub
echo ========================================
echo.
echo 接下来：
echo 1. 访问 https://render.com 部署后端
echo 2. 访问 https://vercel.com 部署前端
echo 3. 详细步骤请查看 DEPLOY.md 文件
echo.
pause
