import os
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# 数据库连接字符串（从环境变量读取，如果没有则使用 SQLite 作为后备）
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://postgres:320324qaz.@@@db.qilsaxyswcnvzdywrdsh.supabase.co:5432/postgres"
)

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()
