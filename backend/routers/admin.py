from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
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
def get_all_deals(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    """后台获取所有优惠（包括已失效的）"""
    deals = db.query(models.Deal).order_by(
        models.Deal.created_at.desc()
    ).offset(skip).limit(limit).all()
    
    return deals


@router.post("/deals", response_model=schemas.DealResponse)
def create_deal(deal: schemas.DealCreate, db: Session = Depends(get_db)):
    """创建新的优惠信息"""
    db_deal = models.Deal(**deal.dict())
    db.add(db_deal)
    db.commit()
    db.refresh(db_deal)
    return db_deal


@router.put("/deals/{deal_id}", response_model=schemas.DealResponse)
def update_deal(deal_id: int, deal: schemas.DealUpdate, db: Session = Depends(get_db)):
    """更新优惠信息"""
    db_deal = db.query(models.Deal).filter(models.Deal.id == deal_id).first()
    
    if not db_deal:
        raise HTTPException(status_code=404, detail="优惠信息不存在")
    
    update_data = deal.dict(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_deal, key, value)
    
    db_deal.updated_at = datetime.now()
    db.commit()
    db.refresh(db_deal)
    
    return db_deal


@router.delete("/deals/{deal_id}")
def delete_deal(deal_id: int, db: Session = Depends(get_db)):
    """删除优惠信息（软删除，设置为无效）"""
    db_deal = db.query(models.Deal).filter(models.Deal.id == deal_id).first()
    
    if not db_deal:
        raise HTTPException(status_code=404, detail="优惠信息不存在")
    
    db_deal.is_active = False
    db_deal.updated_at = datetime.now()
    db.commit()
    
    return {"message": "优惠信息已删除"}
