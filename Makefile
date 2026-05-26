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
COURSE_DB_URL=postgres://$(COURSE_DB_USER):$(COURSE_DB_PASS)@$(COURSE_DB_HOST):$(COURSE_DB_PORT)/$(COURSE_DB_NAME)?sslmode=disable
INVENTORY_DB_URL=postgres://$(INVENTORY_DB_USER):$(INVENTORY_DB_PASS)@$(INVENTORY_DB_HOST):$(INVENTORY_DB_PORT)/$(INVENTORY_DB_NAME)?sslmode=disable

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

migrate-course-up:
	docker compose up -d course-db
	docker compose run --rm \
		-v ../course-service/infra/database/migrations:/migrations \
		migrate -path=/migrations -database "$(COURSE_DB_URL)" \
		up

migrate-course-force:
	docker compose up -d course-db
	docker compose run --rm \
		-v ../course-service/infra/database/migrations:/migrations \
		migrate -path=/migrations -database "$(COURSE_DB_URL)" \
		force $(v)

migrate-course-down:
	docker compose up -d course-db
	docker compose run --rm \
		-v ../course-service/infra/database/migrations:/migrations \
		migrate -path=/migrations -database "$(COURSE_DB_URL)" \
		down $(STEPS)

migrate-inventory-up:
	docker compose up -d inventory-db
	docker compose run --rm \
		-v ../inventory-service/infra/database/migrations:/migrations \
		migrate -path=/migrations -database "$(INVENTORY_DB_URL)" \
		up

migrate-inventory-force:
	docker compose up -d inventory-db
	docker compose run --rm \
		-v ../inventory-service/infra/database/migrations:/migrations \
		migrate -path=/migrations -database "$(INVENTORY_DB_URL)" \
		force $(v)

migrate-inventory-down:
	docker compose up -d inventory-db
	docker compose run --rm \
		-v ../inventory-service/infra/database/migrations:/migrations \
		migrate -path=/migrations -database "$(INVENTORY_DB_URL)" \
		down $(STEPS)
