@echo off
echo ================================
echo 好价分享平台 - 启动脚本
echo ================================
echo.

echo [1/2] 启动后端服务...
cd backend
start "后端服务" cmd /k "uvicorn main:app --reload --port 8000"
cd ..

echo [2/2] 启动前端服务...
cd frontend
start "前端服务" cmd /k "npm run dev"
cd ..

echo.
echo ================================
echo 启动完成！
echo ================================
echo.
echo 后端 API: http://localhost:8000
echo API 文档: http://localhost:8000/docs
echo 前端页面: http://localhost:3000
echo.
echo 按任意键退出...
pause > nul
