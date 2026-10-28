.PHONY: up down logs api-test mobile-install mobile-start

up:
	docker compose up --build

down:
	docker compose down

logs:
	docker compose logs -f api

api-test:
	cd apps/api && pytest

mobile-install:
	cd apps/mobile && npm install

mobile-start:
	cd apps/mobile && npm run start

