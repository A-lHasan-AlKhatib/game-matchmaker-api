# ─── Load .env here ───────────────────────────────────────
ifneq (,$(wildcard .env))
  include .env
  export
endif

# -------------------------------------------------------
# Default goal
# -------------------------------------------------------
.DEFAULT_GOAL := help

# -------------------------------------------------------
# Point help at the actual Makefile (not .env)
# -------------------------------------------------------
MAKEFILE := $(firstword $(MAKEFILE_LIST))

# -------------------------------------------------------
# Configuration (override on CLI: make VAR=val …)
# -------------------------------------------------------
BINARY       ?= main
PKG          ?= ./cmd/game-matchmaker-api
IMAGE        ?= game-matchmaker-api:local
PORT         ?= $(APP_PORT)
DC           ?= docker compose
COMPOSE_FILE ?= -f docker-compose.yaml

# DB dirs
MIG_DIR      ?= db/migrations
SEED_DIR     ?= db/seeds

# Goose wrappers
GOOSE        ?= goose -dir $(MIG_DIR)   postgres "$(DATABASE_URL)"
GOOSE_SEED   ?= goose -dir $(SEED_DIR)  postgres "$(DATABASE_URL)"

# -------------------------------------------------------
# Build & Run
# -------------------------------------------------------
build: ## Compile the server binary
	 go build -o $(BINARY) $(PKG)

run: build ## Build then run locally
	 ./$(BINARY)

# -------------------------------------------------------
# Code Quality
# -------------------------------------------------------
fmt: ## Format all Go code
	 go fmt ./...

vet: fmt ## Run go vet
	 go vet ./...

tidy: ## Tidy modules & verify
	 go mod tidy && go mod verify

test: ## Run unit tests
	 go test ./...

# -------------------------------------------------------
# Docker
# -------------------------------------------------------
docker-build: ## Build the Docker image
	 docker build -t $(IMAGE) .

docker-run: docker-build ## Run container on $(PORT)
	 docker run --rm -p $(PORT):$(PORT) --name $(BINARY) $(IMAGE)

# -------------------------------------------------------
# Docker Compose
# -------------------------------------------------------
compose-up: ## Build & start services in background
	 $(DC) $(COMPOSE_FILE) up -d --build

compose-down: ## Stop & remove services
	 $(DC) $(COMPOSE_FILE) down

compose-logs: ## Stream service logs
	 $(DC) $(COMPOSE_FILE) logs -f

compose-ps: ## List running services
	 $(DC) $(COMPOSE_FILE) ps

compose-restart: ## Recreate & restart services
	 $(DC) $(COMPOSE_FILE) down && $(DC) $(COMPOSE_FILE) up -d --build

# -------------------------------------------------------
# Database Migrations (Goose)
# -------------------------------------------------------
migrate-up:      ## Apply all pending schema migrations
	 @echo "🗄️  Applying schema migrations..."
	 $(GOOSE) up

migrate-down:    ## Roll back the last schema migration
	 @echo "⏪ Rolling back schema migration..."
	 $(GOOSE) down

migrate-status:  ## Show migration status
	 @echo "🔍 Migration status:"
	 $(GOOSE) status

migrate-create:  ## Create a new migration (NAME=<name> TYPE=<sql|go>)
	 @echo "✏️  Creating migration '$(NAME)' of type '$(TYPE)'…"
	 goose -dir $(MIG_DIR) create $(NAME) $(TYPE)

seed-up:         ## Seed the database with initial data
	 @echo "🌱 Seeding database…"
	 $(GOOSE_SEED) up

seed-down:       ## Roll back the last seed batch
	 @echo "⏪ Rolling back seed data…"
	 $(GOOSE_SEED) down

# -------------------------------------------------------
# Cleanup
# -------------------------------------------------------
clean: ## Remove built binary
	 rm -f $(BINARY)

docker-prune: ## Remove unused Docker data
	 docker system prune -f

docker-vol-prune: ## Remove unused Docker volumes
	 docker volume prune -f

# -------------------------------------------------------
# Help
# -------------------------------------------------------
help: ## Show this help
	@grep -E '^[[:alnum:]_-]+:.*## ' $(MAKEFILE) \
	  | awk -F':[^#]*## ' '{printf "  \033[36m%-15s\033[0m %s\n",$$1,$$2}'

# -------------------------------------------------------
# Phony targets
# -------------------------------------------------------
.PHONY: \
  build run fmt vet tidy test \
  docker-build docker-run \
  compose-up compose-down compose-logs compose-ps compose-restart \
  migrate-up migrate-down migrate-status migrate-create \
  seed-up seed-down \
  clean docker-prune docker-vol-prune help
