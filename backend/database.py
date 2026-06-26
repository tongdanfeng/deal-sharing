import os
from datetime import datetime, timezone, timedelta
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# 中国时区 UTC+8
CHINA_TZ = timezone(timedelta(hours=8))

def get_china_time():
    """获取中国时区的当前时间"""
    return datetime.now(CHINA_TZ)

# 数据库连接字符串
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://postgres:320324qaz.@@@db.qilsaxyswcnvzdywrdsh.supabase.co:5432/postgres"
)

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()
