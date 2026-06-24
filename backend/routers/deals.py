from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import datetime
import models
import schemas
from database import SessionLocal

router = APIRouter()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@router.get("/deals", response_model=List[schemas.DealResponse])
def get_deals(
    category: Optional[str] = None,
    skip: int = 0,
    limit: int = 20,
    db: Session = Depends(get_db)
):
    """获取优惠列表（前端展示）"""
    query = db.query(models.Deal).filter(models.Deal.is_active == True)
    
    if category:
        query = query.filter(models.Deal.category == category)
    
    # 推荐的排在前面，然后按创建时间倒序
    deals = query.order_by(
        models.Deal.is_featured.desc(),
        models.Deal.created_at.desc()
    ).offset(skip).limit(limit).all()
    
    return deals


@router.get("/deals/{deal_id}", response_model=schemas.DealResponse)
def get_deal(deal_id: int, db: Session = Depends(get_db)):
    """获取单个优惠详情"""
    deal = db.query(models.Deal).filter(
        models.Deal.id == deal_id,
        models.Deal.is_active == True
    ).first()
    
    if not deal:
        raise HTTPException(status_code=404, detail="优惠信息不存在")
    
    return deal


@router.get("/categories", response_model=List[str])
def get_categories(db: Session = Depends(get_db)):
    """获取所有分类"""
    categories = db.query(models.Deal.category).filter(
        models.Deal.is_active == True,
        models.Deal.category.isnot(None)
    ).distinct().all()
    
    return [cat[0] for cat in categories if cat[0]]
