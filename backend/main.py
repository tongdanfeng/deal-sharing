from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from database import engine, Base
from routers import deals, admin

# 创建数据库表
Base.metadata.create_all(bind=engine)

app = FastAPI(title="好价分享平台", description="分享和 manage 优惠信息的平台")

# 配置 CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 注册路由
app.include_router(deals.router, prefix="/api", tags=["deals"])
app.include_router(admin.router, prefix="/api/admin", tags=["admin"])

@app.get("/")
async def root():
    return {"message": "好价分享平台 API"}
