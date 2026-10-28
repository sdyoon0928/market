# NAVER Cloud 배포 메모

MVP는 NCP Server 한 대에 Docker Compose로 API와 PostgreSQL을 배포하는 구성을 우선합니다.

운영 전 체크리스트:

1. Ubuntu Server 생성 및 ACG에서 80/443만 공개
2. Docker Engine과 Compose 설치
3. 운영용 `.env`에 강한 DB 암호와 허용 도메인 설정
4. Caddy 또는 Nginx로 HTTPS 종료
5. PostgreSQL 볼륨 스냅샷과 주기 백업 설정
6. API 로그와 서버 모니터링 연결

사용자가 늘어나면 PostgreSQL을 Cloud DB for PostgreSQL로 분리합니다.

