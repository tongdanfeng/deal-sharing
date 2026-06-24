@echo off
chcp 65001 >nul
echo ========================================
echo 隐藏后台管理入口
echo ========================================
echo.

cd /d d:\tdfpy\deal_sharing

REM 设置 Git 路径
set GIT_PATH=D:\Program Files\Git\cmd\git.exe
if not exist "%GIT_PATH%" set GIT_PATH=D:\Program Files\Git\bin\git.exe

echo 正在推送...
echo.

"%GIT_PATH%" add frontend/src/App.vue
"%GIT_PATH%" commit -m "隐藏后台管理导航链接"
"%GIT_PATH%" push origin main

echo.
if %errorlevel% equ 0 (
    echo ✅ 推送成功！
) else (
    echo ❌ 推送失败
)
echo.

pause
