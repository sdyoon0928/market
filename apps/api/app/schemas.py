import uuid
from decimal import Decimal

from pydantic import BaseModel, ConfigDict


class MarketSummary(BaseModel):
    market_id: uuid.UUID
    name: str
    market_type: str | None = None
    open_cycle: str | None = None
    road_address: str | None = None
    latitude: Decimal
    longitude: Decimal
    item_categories: str | None = None

    model_config = ConfigDict(from_attributes=True)

