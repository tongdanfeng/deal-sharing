@echo off
chcp 65001 >nul
echo ========================================
echo 检查 Git 状态并推送
echo ========================================
echo.

cd /d d:\tdfpy\deal_sharing

REM 设置 Git 路径
set GIT_PATH=D:\Program Files\Git\cmd\git.exe
if not exist "%GIT_PATH%" set GIT_PATH=D:\Program Files\Git\bin\git.exe
if not exist "%GIT_PATH%" set GIT_PATH=C:\Program Files\Git\cmd\git.exe
if not exist "%GIT_PATH%" set GIT_PATH=C:\Program Files\Git\bin\git.exe

echo [1/4] 查看当前状态...
"%GIT_PATH%" status

echo.
echo [2/4] 添加所有修改...
"%GIT_PATH%" add .

echo.
echo [3/4] 提交修改...
"%GIT_PATH%" commit -m "修复 Render 部署配置 - 设置 rootDirectory 为 backend"

echo.
echo [4/4] 推送到 GitHub...
"%GIT_PATH%" push origin main

echo.
echo ========================================
echo 完成！
echo ========================================
echo.
echo 如果看到 "Everything up-to-date" 说明已经推送过了
echo 如果有 "Writing objects" 说明正在推送
echo.
pause
