# --- Builder Stage ---
FROM golang:1.24.2-alpine AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -o main ./cmd/game-matchmaker-api

# --- Final Runtime Image ---
FROM alpine:3.20

WORKDIR /app

# Copy only the compiled binary from the builder stage
COPY --from=builder /app/main .

EXPOSE 8080

CMD ["./main"]
