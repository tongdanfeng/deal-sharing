@echo off
chcp 65001 >nul
echo ========================================
echo 修复 Netlify 路由配置
echo ========================================
echo.

cd /d d:\tdfpy\deal_sharing

REM 设置 Git 路径
set GIT_PATH=D:\Program Files\Git\cmd\git.exe
if not exist "%GIT_PATH%" set GIT_PATH=D:\Program Files\Git\bin\git.exe

echo 正在推送...
echo.

"%GIT_PATH%" add frontend/public/_redirects
"%GIT_PATH%" commit -m "添加Netlify重定向规则修复404"
"%GIT_PATH%" push origin main

echo.
if %errorlevel% equ 0 (
    echo ✅ 推送成功！
) else (
    echo ❌ 推送失败
)
echo.

pause
