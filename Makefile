# -------------------------------------------------------
# Default goal
# -------------------------------------------------------
.DEFAULT_GOAL := help

# -------------------------------------------------------
# Configuration (override on CLI: make IMAGE=foo:bar ...)
# -------------------------------------------------------
BINARY        ?= main
PKG           ?= ./cmd/game-matchmaker-api
IMAGE         ?= game-matchmaker-api:local
PORT          ?= 8080
DC            ?= docker compose
COMPOSE_FILE  ?= -f docker-compose.yaml

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
fmt: ## go fmt all packages
	go fmt ./...

vet: fmt ## Static analysis
	go vet ./...

tidy: ## Tidy & verify modules
	go mod tidy && go mod verify

test: ## Run tests
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
compose-up: ## Build & start all services in background
	$(DC) $(COMPOSE_FILE) up -d --build

compose-down: ## Stop & remove services
	$(DC) $(COMPOSE_FILE) down

compose-logs: ## Stream service logs
	$(DC) $(COMPOSE_FILE) logs -f

compose-ps: ## List running services
	$(DC) $(COMPOSE_FILE) ps

compose-restart: ## Recreate & restart all services
	$(DC) $(COMPOSE_FILE) down && $(DC) $(COMPOSE_FILE) up -d --build

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
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-15s\033[0m %s\n",$1,$2}'

# -------------------------------------------------------
# Phony targets
# -------------------------------------------------------
.PHONY: \
	build run fmt vet tidy test \
	docker-build docker-run \
	compose-up compose-down compose-logs compose-ps compose-restart \
	clean docker-prune docker-vol-prune help
