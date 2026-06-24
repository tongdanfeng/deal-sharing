@echo off
chcp 65001 >nul
echo ========================================
echo 推送前端更新到 GitHub
echo ========================================
echo.

cd /d d:\tdfpy\deal_sharing

REM 设置 Git 路径
set GIT_PATH=D:\Program Files\Git\cmd\git.exe
if not exist "%GIT_PATH%" set GIT_PATH=D:\Program Files\Git\bin\git.exe
if not exist "%GIT_PATH%" set GIT_PATH=C:\Program Files\Git\cmd\git.exe
if not exist "%GIT_PATH%" set GIT_PATH=C:\Program Files\Git\bin\git.exe

echo 正在推送...
echo.

"%GIT_PATH%" add frontend/src/api.js
"%GIT_PATH%" commit -m "更新前端API地址到Render后端"
"%GIT_PATH%" push origin main

echo.
if %errorlevel% equ 0 (
    echo ✅ 推送成功！
) else (
    echo ❌ 推送失败
)
echo.

pause
