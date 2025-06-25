# Start from an official Go base image
FROM golang:1.24.2-alpine

# Set working directory
WORKDIR /app

# Copy go.mod and go.sum first (for caching)
COPY go.mod go.sum ./
RUN go mod download

# Copy the full source
COPY . .

# Build the Go binary
RUN go build -o main ./cmd/game-matchmaker-api

# Expose default app port
EXPOSE 8080

# Run the application
CMD ["./main"]
