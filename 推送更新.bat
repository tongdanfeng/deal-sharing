@echo off
chcp 65001 >nul
echo ========================================
echo 推送更新到 GitHub
echo ========================================
echo.

cd /d d:\tdfpy\deal_sharing

REM 设置 Git 路径
set GIT_PATH=D:\Program Files\Git\cmd\git.exe
if not exist "%GIT_PATH%" set GIT_PATH=D:\Program Files\Git\bin\git.exe
if not exist "%GIT_PATH%" set GIT_PATH=C:\Program Files\Git\cmd\git.exe
if not exist "%GIT_PATH%" set GIT_PATH=C:\Program Files\Git\bin\git.exe

echo 添加修改的文件...
"%GIT_PATH%" add .

echo 提交更新...
"%GIT_PATH%" commit -m "修复 Render 部署配置"

echo 推送到 GitHub...
"%GIT_PATH%" push

echo.
echo ========================================
echo ✅ 推送完成！
echo ========================================
echo.
echo 现在回到 Render 页面：
echo 1. 点击 "Manual Deploy"
echo 2. 选择 "Deploy latest commit"
echo 3. 等待部署完成
echo.
pause
