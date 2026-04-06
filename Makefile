# Makefile для миграций
include .env
export

.PHONY: migrate-create migrate-up migrate-down migrate-force migrate-version

# URL базы данных
DB_URL ?= postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}?sslmode=disable

# Создать новую миграцию (универсальный вариант)
migrate-create:
ifeq ($(OS),Windows_NT)
	@powershell -Command "$$name = Read-Host 'Please enter new migration name'; migrate create -ext sql -dir migrations -seq $$name"
else
	@read -p "Please enter new migration name: " name; \
	migrate create -ext sql -dir migrations -seq $$name
endif

# Создать миграцию через аргумент (рекомендуемый способ)
migrate-create-arg:
	migrate create -ext sql -dir migrations -seq $(name)

# Применить все миграции
migrate-up:
	migrate -path migrations -database "$(DB_URL)" up

# Откатить последнюю миграцию
migrate-down:
	migrate -path migrations -database "$(DB_URL)" down 1

# Откатить на N миграций
migrate-down-n:
ifeq ($(OS),Windows_NT)
	@powershell -Command "$$steps = Read-Host 'How much N migration need to rollback?'; migrate -path migrations -database \"$(DB_URL)\" down $$steps"
else
	@read -p "How much N migration need to rollback?: " steps; \
	migrate -path migrations -database "$(DB_URL)" down $$steps
endif

# Применить N миграций
migrate-up-n:
ifeq ($(OS),Windows_NT)
	@powershell -Command "$$steps = Read-Host 'Apply N migration(s)'; migrate -path migrations -database \"$(DB_URL)\" up $$steps"
else
	@read -p "Apply N migration(s): " steps; \
	migrate -path migrations -database "$(DB_URL)" up $$steps
endif

# Показать текущую версию
migrate-version:
	migrate -path migrations -database "$(DB_URL)" version

# Принудительно установить версию (опасно!)
migrate-force:
ifeq ($(OS),Windows_NT)
	@powershell -Command "$$version = Read-Host 'Enter version for force migration install'; migrate -path migrations -database \"$(DB_URL)\" force $$version"
else
	@read -p "Enter version for force migration install: " version; \
	migrate -path migrations -database "$(DB_URL)" force $$version
endif

# Создать все таблицы (для разработки)
setup-db: migrate-up

# Сбросить базу (удалить все таблицы)
reset-db:
	migrate -path migrations -database "$(DB_URL)" down -all

# --- Миграции из Docker (postgres = имя сервиса в docker-compose) ---
DB_URL_DOCKER = postgres://$(POSTGRES_USER):$(POSTGRES_PASSWORD)@postgres:5432/$(POSTGRES_DB)?sslmode=disable

migrate-up-docker:
	docker compose --profile tools run --rm migrate -path /migrations -database "$(DB_URL_DOCKER)" up

migrate-down-docker:
	docker compose --profile tools run --rm migrate -path /migrations -database "$(DB_URL_DOCKER)" down 1

migrate-version-docker:
	docker compose --profile tools run --rm migrate -path /migrations -database "$(DB_URL_DOCKER)" version