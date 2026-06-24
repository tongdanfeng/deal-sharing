@echo off
chcp 65001 >nul
echo ========================================
echo 重新推送修复 404 问题
echo ========================================
echo.

cd /d d:\tdfpy\deal_sharing

REM 设置 Git 路径
set GIT_PATH=D:\Program Files\Git\cmd\git.exe
if not exist "%GIT_PATH%" set GIT_PATH=D:\Program Files\Git\bin\git.exe

echo 正在推送...
echo.

"%GIT_PATH%" add -A
"%GIT_PATH%" commit -m "修复：添加_netlify重定向规则"
"%GIT_PATH%" push origin main

echo.
if %errorlevel% equ 0 (
    echo ✅ 推送成功！
    echo.
    echo 请等待 1-2 分钟让 Netlify 重新部署
    echo 然后访问：https://lovely-lamington-355d87.netlify.app/admin
) else (
    echo ❌ 推送失败
)
echo.

pause
