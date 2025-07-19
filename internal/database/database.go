package database

import (
    "fmt"
    "gorm.io/driver/postgres"
    "gorm.io/gorm"
    "log"
    "os"
)

// Connect to the Postgres database using GORM
func Connect() (*gorm.DB, error) {
    // Read environment variables
    user := os.Getenv("DB_USERNAME")
    pass := os.Getenv("DB_PASS")
    host := os.Getenv("DB_HOST")
    port := os.Getenv("DB_PORT")
    name := os.Getenv("DB_NAME")
    ssl_mode := os.Getenv("DB_SSLMODE")

    dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=%s",
        host, user, pass, name, port, ssl_mode)
    db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
    if err != nil {
        return nil, fmt.Errorf("failed to connect to the database: %v", err)
    }

    log.Println("Connected to the database")

    return db, nil

}

// Close closes the database connection
func Close(db *gorm.DB) {
    if db != nil {
        sqlDB, err := db.DB()
        if err != nil {
            log.Printf("Failed to get underlying DB connection: %v", err)
            return
        }
        sqlDB.Close()
        log.Println("Database connection closed")
    }
}
