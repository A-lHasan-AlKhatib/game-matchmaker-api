# -------------------------------------------------------
# Variables (override on CLI:  make IMAGE=myapp:dev docker-build )
# -------------------------------------------------------
BINARY ?= main
PKG    ?= ./cmd/game-matchmaker-api
IMAGE  ?= game-matchmaker-api:local
PORT   ?= 8080

# -------------------------------------------------------
# Build / Run
# -------------------------------------------------------
build: ## Compile the server binary
	go build -o $(BINARY) $(PKG)

run: build ## Build then start the server locally
	./$(BINARY)

# -------------------------------------------------------
# Quality
# -------------------------------------------------------
tidy: ## Ensure go.mod / go.sum are tidy & verified
	go mod tidy && go mod verify

fmt: ## go fmt every package
	go fmt ./...

vet: ## Static analysis
	go vet ./...

test: ## Run all unit/integration tests
	go test ./...

# -------------------------------------------------------
# Docker helpers
# -------------------------------------------------------
docker-build: ## Build local Docker image
	docker build -t $(IMAGE) .

docker-run: docker-build ## Build image, then run container on $(PORT)
	docker run --rm -p $(PORT):$(PORT) --name game-matchmaker-api $(IMAGE)

# -------------------------------------------------------
# Misc
# -------------------------------------------------------
clean: ## Remove binary
	rm -f $(BINARY)

help: ## List all make targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

.PHONY: build run tidy fmt vet test docker-build docker-run clean help
