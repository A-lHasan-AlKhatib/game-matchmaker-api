package models

import (
    "database/sql/driver"
    "encoding/json"
    "time"

    "gorm.io/gorm"
)

// JSONB is a helper type so GORM will marshal/unmarshal JSONB columns.
type JSONB map[string]interface{}

func (j *JSONB) Scan(src interface{}) error {
    return json.Unmarshal(src.([]byte), j)
}

func (j JSONB) Value() (driver.Value, error) {
    return json.Marshal(j)
}

// User maps to your users table created via Goose.
type User struct {
    ID              uint           `gorm:"primaryKey;column:id"`
    FirstName       string         `gorm:"column:first_name;not null"`
    LastName        string         `gorm:"column:last_name;not null"`
    Username        string         `gorm:"column:username;unique;not null"`
    Email           string         `gorm:"column:email;unique;not null"`
    PasswordHash    string         `gorm:"column:password_hash;not null"`
    Role            string         `gorm:"column:role;not null;default:user"`
    IsActive        bool           `gorm:"column:is_active;not null;default:true"`
    EmailVerifiedAt *time.Time     `gorm:"column:email_verified_at"`
    LastLoginAt     *time.Time     `gorm:"column:last_login_at"`
    PhoneNumber     *string        `gorm:"column:phone_number"`
    ProfilePicture  *string        `gorm:"column:profile_picture"`
    Preferences     JSONB          `gorm:"column:preferences;type:jsonb"`
    CreatedAt       time.Time      `gorm:"column:created_at;autoCreateTime"`
    UpdatedAt       time.Time      `gorm:"column:updated_at;autoUpdateTime"`
    DeletedAt       gorm.DeletedAt `gorm:"column:deleted_at;index"`
}
