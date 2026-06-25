from sqlalchemy import Column, Integer, String, Float, DateTime, Boolean, Text
from database import Base, get_china_time


class Deal(Base):
    __tablename__ = "deals"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(200), nullable=False, comment="优惠标题")
    description = Column(Text, comment="优惠描述")
    original_price = Column(Float, comment="原价")
    deal_price = Column(Float, comment="优惠价")
    discount = Column(Float, comment="折扣力度（如：5折）")
    category = Column(String(50), comment="分类（数码、食品、家居等）")
    merchant = Column(String(100), comment="商家/平台名称")
    link = Column(String(500), comment="购买链接")
    image_url = Column(String(500), comment="商品图片URL")
    coupon_code = Column(String(100), comment="优惠码")
    is_active = Column(Boolean, default=True, comment="是否有效")
    is_featured = Column(Boolean, default=False, comment="是否推荐")
    created_at = Column(DateTime(timezone=True), default=get_china_time)
    updated_at = Column(DateTime(timezone=True), onupdate=get_china_time)
    expire_at = Column(DateTime(timezone=True), comment="过期时间")
