from fastapi import APIRouter, Depends, Query
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.database import get_db
from app.models import Market
from app.schemas import MarketSummary

router = APIRouter(prefix="/markets", tags=["markets"])


@router.get("", response_model=list[MarketSummary])
def list_markets(
    limit: int = Query(default=20, ge=1, le=100),
    db: Session = Depends(get_db),
) -> list[Market]:
    return list(db.scalars(select(Market).order_by(Market.name).limit(limit)))

