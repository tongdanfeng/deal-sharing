@echo off
chcp 65001 >nul
echo ========================================
echo 构建前端项目
echo ========================================
echo.

cd /d d:\tdfpy\deal_sharing\frontend

echo 正在构建...
echo.

call npm run build

echo.
if %errorlevel% equ 0 (
    echo ========================================
    echo ✅ 构建成功！
    echo ========================================
    echo.
    echo 构建文件在：d:\tdfpy\deal_sharing\frontend\dist
    echo.
    echo 接下来：
    echo 1. 访问 https://app.netlify.com/drop
    echo 2. 把 dist 文件夹拖到网页上
    echo 3. 完成部署！
    echo.
) else (
    echo ========================================
    echo ❌ 构建失败
    echo ========================================
    echo.
)

pause
