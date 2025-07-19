package main

import (
    "context"
    "log"
    "net/http"
    "os/signal"
    "syscall"
    "time"

    "github.com/A-lHasan-AlKhatib/game-matchmaker-api/internal/server"
)

func gracefulShutdown(apiSrv *http.Server, done chan bool) {
    // Listen for SIGINT/SIGTERM on a cancellable context
    ctx, stop := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
    defer stop()

    <-ctx.Done() // blocking until signal

    log.Println("Shutting down gracefully, press Ctrl+C again to force")
    // give in-flight requests up to 5s to complete
    shutdownCtx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
    defer cancel()

    if err := apiSrv.Shutdown(shutdownCtx); err != nil {
        log.Printf("Forced shutdown with error: %v", err)
    }

    log.Println("Server exited")
    done <- true
}

func main() {
    // 1) Build the HTTP server
    apiSrv, err := server.NewServer()
    if err != nil {
        log.Fatalf("Failed to initialize server: %v", err)
    }

    // 2) Set up graceful shutdown
    done := make(chan bool, 1)
    go gracefulShutdown(apiSrv, done)

    // 3) Start serving
    log.Printf("Starting server on %s\n", apiSrv.Addr)
    if err := apiSrv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
        log.Fatalf("HTTP server error: %v", err)
    }

    // 4) Wait for shutdown to finish
    <-done
    log.Println("Graceful shutdown complete.")
}
