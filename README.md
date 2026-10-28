# 길따라장따라 (Market)

광주·전남 전통시장과 주변 관광지를 묶어 개인화 여행 일정을 만드는 모바일 앱 MVP입니다.

## 기술 구성

- 모바일: Expo, React Native, TypeScript, Expo Router
- API: FastAPI, SQLAlchemy, Pydantic
- 데이터베이스: PostgreSQL
- 로컬/배포: Docker Compose
- 배포 대상: NAVER Cloud Platform Server

## 폴더 구조

```text
apps/
  mobile/          Expo 모바일 앱
  api/             FastAPI 백엔드
docs/solo_mvp/     PRD, 스키마, ERD, 화면·추천 흐름
infra/             배포 환경 예시
scripts/           데이터 적재 스크립트 위치
```

## 빠른 시작

1. `.env.example`을 `.env`로 복사합니다.
2. API와 DB를 실행합니다: `docker compose up --build`
3. 모바일 앱을 실행합니다: `cd apps/mobile && npm install && npm run start`
4. 실제 휴대폰에서 테스트할 때는 `.env`의 `EXPO_PUBLIC_API_URL`을 PC의 같은 Wi-Fi IP로 바꿉니다.

API 문서: `http://localhost:8000/docs`  
상태 확인: `http://localhost:8000/api/v1/health`

## Cursor 사용

Cursor에서 이 저장소 루트를 열고 `.cursor/rules/project.mdc`의 규칙을 기준으로 작업합니다.

## 현재 구현 범위

- 모바일 홈/여행 조건 입력 화면 뼈대
- FastAPI 상태 확인 및 시장 목록 API
- PostgreSQL 초기 스키마 자동 적용
- Docker 기반 로컬 개발 환경

상세 범위와 출시 기준은 `docs/solo_mvp/PRD.md`를 참고하세요.

