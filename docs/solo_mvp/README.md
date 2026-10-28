# 길따라장따라 1인 개발 MVP 문서

이 폴더는 기존 팀 프로젝트를 여행자 중심의 1인 개발 MVP로 축소한 기준 문서다. 모든 문서는 동일한 범위를 사용한다.

## 기준 범위

- 모바일 앱: React Native Expo
- 백엔드: FastAPI
- 데이터베이스: PostgreSQL
- 배포: NAVER Cloud Platform Server와 Docker Compose
- 초기 지역: 광주·전남
- 핵심 경험: 여행 조건 입력 → 장날에 맞는 시장 선택 → 주변 장소 조합 → 이동시간 반영 → 일정 저장 → 방문 기록과 리뷰
- 제외: 상인 입점, 관리자 대시보드, 결제, 정산, 쿠폰, 스탬프 투어, 실시간 혼잡도

## 문서 목록

- `PRD.md`: 제품 목표, 범위, 사용자 스토리, 요구사항, KPI, 출시 기준
- `schema.sql`: PostgreSQL 초기 스키마
- `erd.mmd`: 축소 ERD Mermaid 원본
- `screen_flow.mmd`: 모바일 화면 흐름 Mermaid 원본
- `recommendation_workflow.mmd`: 추천 생성 워크플로우 Mermaid 원본
- `public_data_plan.md`: 공공데이터 수집 우선순위와 적재 규칙

## 기존 자산에 대한 판단

- 기존 SQLite DB는 23개 테이블을 가지지만 데이터가 있는 테이블은 `MARKET` 121건과 `MARKET_STALL` 10,264건뿐이다.
- 기존 CSV에는 광주·전남 119개 시장과 10,264개 상가 매칭 데이터가 들어 있다.
- 기존 PRD는 사용자·상인·관리자와 여러 로그인 방식을 동시에 Must로 두고 있어 1인 MVP 범위를 초과한다.
- 기존 노트북의 CSV 적재 로직과 시장·점포 정제 로직은 재사용 후보이고, Gradio UI와 빈 확장 테이블은 재작성 대상으로 본다.

