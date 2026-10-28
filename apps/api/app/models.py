import uuid
from decimal import Decimal

from sqlalchemy import Numeric, String, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class Market(Base):
    __tablename__ = "market"

    market_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True)
    name: Mapped[str] = mapped_column(String(200))
    market_type: Mapped[str | None] = mapped_column(String(50))
    open_cycle: Mapped[str | None] = mapped_column(String(50))
    road_address: Mapped[str | None] = mapped_column(String(255))
    latitude: Mapped[Decimal] = mapped_column(Numeric(10, 7))
    longitude: Mapped[Decimal] = mapped_column(Numeric(10, 7))
    item_categories: Mapped[str | None] = mapped_column(Text)

