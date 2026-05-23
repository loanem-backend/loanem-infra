SHELL := cmd.exe

build:
	docker compose build --parallel=false

up:
	docker compose up -d

down:
	docker compose down

include .env
export

STEPS ?= 1

AUTH_DB_URL=postgres://$(AUTH_DB_USER):$(AUTH_DB_PASS)@$(AUTH_DB_HOST):$(AUTH_DB_PORT)/$(AUTH_DB_NAME)?sslmode=disable

migrate-auth-up:
	docker compose up -d auth-db
	docker compose run --rm \
		-v ../auth-service/infra/database/migrations:/migrations \
		migrate -path=/migrations -database "$(AUTH_DB_URL)" \
		up

migrate-auth-force:
	docker compose up -d auth-db
	docker compose run --rm \
		-v ../auth-service/infra/database/migrations:/migrations \
		migrate -path=/migrations -database "$(AUTH_DB_URL)" \
		force $(v)

migrate-auth-down:
	docker compose up -d auth-db
	docker compose run --rm \
		-v ../auth-service/infra/database/migrations:/migrations \
		migrate -path=/migrations -database "$(AUTH_DB_URL)" \
		down $(STEPS)
