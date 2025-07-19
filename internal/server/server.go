package server

import (
    "fmt"
<<<<<<< HEAD
=======
    "gorm.io/gorm"
>>>>>>> 0a4a71f (feat(db): add users table migration, seed data, and GORM model; update config)
    "net/http"
    "os"
    "strconv"
    "time"

    _ "github.com/joho/godotenv/autoload"

    "github.com/A-lHasan-AlKhatib/game-matchmaker-api/internal/database"
)

type Server struct {
    port int
<<<<<<< HEAD

    db database.Service
}

func NewServer() *http.Server {
    port, _ := strconv.Atoi(os.Getenv("APP_PORT"))
    NewServer := &Server{
        port: port,

        db: database.New(),
    }

    // Declare Server config
    server := &http.Server{
        Addr:         fmt.Sprintf(":%d", NewServer.port),
        Handler:      NewServer.RegisterRoutes(),
        IdleTimeout:  time.Minute,
        ReadTimeout:  10 * time.Second,
        WriteTimeout: 30 * time.Second,
    }

    return server
=======
    db   *gorm.DB
}

func NewServer() (*http.Server, error) {
    port, _ := strconv.Atoi(os.Getenv("APP_PORT"))

    db, err := database.Connect()
    if err != nil {
        return nil, fmt.Errorf("failed to initialize server: %v", err)
    }

    NewServer := &Server{
        port: port,
        db:   db,
    }

    // Declare Server config
    server := &http.Server{
        Addr:         fmt.Sprintf(":%d", NewServer.port),
        Handler:      NewServer.RegisterRoutes(),
        IdleTimeout:  time.Minute,
        ReadTimeout:  10 * time.Second,
        WriteTimeout: 30 * time.Second,
    }

    return server, nil
>>>>>>> 0a4a71f (feat(db): add users table migration, seed data, and GORM model; update config)
}
