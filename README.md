# Game Matchmaker API 🎮

An API-first backend service built with Go to help users organize friendly sports matches by connecting teams and players.

## Features

- Match players with partial teams
- Playground/location-based filtering
- User registration and authentication
- API-first with OpenAPI
- Built with Gin, GORM, PostgreSQL

## Getting Started

## Development commands 🛠

| Command | What it does |
|---------|--------------|
| `make tidy` | Tidy and verify Go modules |
| `make build` | Compile the binary to `./main` |
| `make run` | Build then run the server on port 8080 |
| `make test` | Run all unit & integration tests |
| `make docker-build` | Build the Docker image (`game-matchmaker-api:local`) |
| `make docker-run` | Build the image and run it, exposing port 8080 |
| `make fmt` / `make vet` | Formatting & static analysis |
| `make clean` | Remove compiled binary |

Run `make` without arguments to see all targets.
