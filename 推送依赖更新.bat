@echo off
chcp 65001 >nul
echo ========================================
echo 推送 requirements.txt 更新到 GitHub
echo ========================================
echo.

cd /d d:\tdfpy\deal_sharing

REM 设置 Git 路径
set GIT_PATH=D:\Program Files\Git\cmd\git.exe
if not exist "%GIT_PATH%" set GIT_PATH=D:\Program Files\Git\bin\git.exe
if not exist "%GIT_PATH%" set GIT_PATH=C:\Program Files\Git\cmd\git.exe
if not exist "%GIT_PATH%" set GIT_PATH=C:\Program Files\Git\bin\git.exe

echo 正在推送更新...
echo.

"%GIT_PATH%" add backend/requirements.txt
"%GIT_PATH%" commit -m "修复依赖版本 - 使用>=避免编译错误"
"%GIT_PATH%" push origin main

echo.
if %errorlevel% equ 0 (
    echo ========================================
    echo ✅ 推送成功！
    echo ========================================
    echo.
    echo Render 应该会自动重新部署
    echo 如果没有，请在 Render 上点击 Manual Deploy
    echo.
) else (
    echo ========================================
    echo ❌ 推送失败！
    echo ========================================
    echo.
    echo 网络连接不上 GitHub
    echo 请使用网页方式修改 requirements.txt：
    echo 1. 访问 https://github.com/tongdanfeng/deal-sharing
    echo 2. 进入 backend 文件夹
    echo 3. 点击 requirements.txt
    echo 4. 点击编辑按钮（铅笔图标）
    echo 5. 修改内容为：
    echo    fastapi^>=0.109.0
    echo    uvicorn^>=0.27.0
    echo    sqlalchemy^>=2.0.25
    echo    pydantic^>=2.5.3
    echo 6. 点击 Commit changes
    echo.
)

pause
