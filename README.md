# Game Matchmaker API 🎮

A Go-based API service for matching players to sports games (e.g., football, volleyball) with Docker Compose and Makefile support for local development.

---

## Table of Contents

* [Features](#features)
* [Prerequisites](#prerequisites)
* [Project Setup](#project-setup)
* [Configuration](#configuration)
* [Makefile Commands](#makefile-commands)
* [Docker](#docker)
* [Docker Compose](#docker-compose)
* [License](#license)
---

## Features

- Match players with partial teams
- Playground/location-based filtering
- User registration and authentication
- API-first with OpenAPI
- Built with Gin, GORM, PostgreSQL

## Prerequisites

* Go 1.24.4+ installed locally (for non-Docker builds)
* Docker Engine & Docker Compose v2
* (Optional) Make (generally available on Linux/macOS)

---

## Project Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/A-lHasan-AlKhatib/game-matchmaker-api.git
   cd game-matchmaker-api
   ```

2. **Create a ****`.env`**** file** in the project root:

   ```dotenv
   PORT==****
   DB_HOST=****
   DB_PORT==****
   DB_NAME==****
   DB_USERNAME==****
   DB_PASSWORD==****
   ```

3. **Verify the Dockerfile** and ensure the service binary is built at `/app/main`.

---

## Configuration

| Variable      | Default   | Description                     |
| ------------- | --------- | ------------------------------- |
| `PORT`        | `8080`    | HTTP port where the API listens |
| `DB_HOST`     | `psql_db` | Hostname for PostgreSQL service |
| `DB_PORT`     | `5432`    | Port for PostgreSQL             |
| `DB_NAME`     | `matchdb` | Database name                   |
| `DB_USERNAME` | `root`    | Database user                   |
| `DB_PASSWORD` | `root`    | Database password               |
| `DB_SCHEMA`   | `public`  | DB schema (default: public)     |
| `DB_SSLMODE`  | `disable` | SSL mode for DB connection      |

---

## Makefile Commands

Use `make` to streamline common tasks. Running `make` or `make help` shows all targets.

| Target              | Description                                |
| ------------------- | ------------------------------------------ |
| `make build`        | Compile the Go binary                      |
| `make run`          | Build and run the binary locally           |
| `make fmt`          | Format code with `go fmt`                  |
| `make vet`          | Run `go vet` for static analysis           |
| `make tidy`         | Clean and verify `go.mod` and `go.sum`     |
| `make test`         | Run all tests                              |
| `make docker-build` | Build the Docker image                     |
| `make docker-run`   | Build image and run container on `$(PORT)` |
| `make compose-up`   | Build & start services with Docker Compose |
| `make compose-down` | Stop and remove Compose services           |
| `make compose-logs` | Tail logs for Compose services             |
| `make clean`        | Remove compiled binary                     |

---

## Docker

* **Build locally:**

  ```bash
  make docker-build
  ```

* **Run container:**

  ```bash
  make docker-run
  ```

* **Prune unused data:**

  ```bash
  make docker-prune
  make docker-vol-prune
  ```

---

## Docker Compose

* **Start services:**

  ```bash
  make compose-up
  ```

* **View logs:**

  ```bash
  make compose-logs
  ```

* **Stop services:**

  ```bash
  make compose-down
  ```

* **Rebuild & restart:**

  ```bash
  make compose-restart
  ```

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
