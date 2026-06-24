from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class DealBase(BaseModel):
    title: str
    description: Optional[str] = None
    original_price: Optional[float] = None
    deal_price: Optional[float] = None
    discount: Optional[float] = None
    category: Optional[str] = None
    merchant: Optional[str] = None
    link: Optional[str] = None
    image_url: Optional[str] = None
    coupon_code: Optional[str] = None
    is_active: bool = True
    is_featured: bool = False
    expire_at: Optional[datetime] = None


class DealCreate(DealBase):
    pass


class DealUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    original_price: Optional[float] = None
    deal_price: Optional[float] = None
    discount: Optional[float] = None
    category: Optional[str] = None
    merchant: Optional[str] = None
    link: Optional[str] = None
    image_url: Optional[str] = None
    coupon_code: Optional[str] = None
    is_active: Optional[bool] = None
    is_featured: Optional[bool] = None
    expire_at: Optional[datetime] = None


class DealResponse(DealBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True
