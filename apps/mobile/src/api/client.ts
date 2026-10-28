const API_URL = process.env.EXPO_PUBLIC_API_URL ?? "http://localhost:8000";

export type MarketSummary = {
  market_id: string;
  name: string;
  market_type: string | null;
  open_cycle: string | null;
  road_address: string | null;
  latitude: string;
  longitude: string;
  item_categories: string | null;
};

export async function getMarkets(): Promise<MarketSummary[]> {
  const response = await fetch(`${API_URL}/api/v1/markets`);
  if (!response.ok) throw new Error("시장 정보를 불러오지 못했습니다.");
  return response.json();
}

