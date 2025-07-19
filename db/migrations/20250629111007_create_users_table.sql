-- +goose Up
-- +goose StatementBegin
CREATE TABLE users (
                       id                SERIAL PRIMARY KEY,
                       first_name        TEXT    NOT NULL,
                       last_name         TEXT    NOT NULL,
                       username          TEXT    UNIQUE    NOT NULL,
                       email             TEXT    UNIQUE    NOT NULL,
                       password_hash     TEXT    NOT NULL,
                       role              TEXT    NOT NULL DEFAULT 'user',
                       is_active         BOOLEAN NOT NULL DEFAULT TRUE,
                       email_verified_at TIMESTAMP WITH TIME ZONE,
                       last_login_at     TIMESTAMP WITH TIME ZONE,
                       phone_number      TEXT,
                       profile_picture   TEXT,
                       preferences       JSONB,
                       created_at        TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
                       updated_at        TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
                       deleted_at        TIMESTAMP WITH TIME ZONE
);

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS users;
-- +goose StatementEnd
