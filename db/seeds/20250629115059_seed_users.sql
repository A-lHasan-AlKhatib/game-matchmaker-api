-- +goose Up
-- +goose StatementBegin
INSERT INTO users
(first_name, last_name, username, email, password_hash,
 role, is_active, email_verified_at, last_login_at,
 phone_number, profile_picture, preferences, created_at, updated_at)
VALUES
    ('Alice', 'Smith',   'alice',   'alice@example.com',
     '$2a$10$abcdefghijklmnopqrstuv',  -- bcrypt("password1")
     'user', TRUE, now(), NULL,
     '555-000-0001', '', '{"theme":"light","notifications":{"email":true,"sms":false}}'::jsonb,
     now(), now()
    ),
    ('Bob',   'Jones',   'bobby',   'bob@example.com',
     '$2a$10$abcdefghijklmnopqrstuv',
     'user', TRUE, now(), NULL,
     '555-000-0002', '', '{"theme":"dark","notifications":{"email":true,"sms":true}}'::jsonb,
     now(), now()
    ),
    ('Carol', 'Lee',     'carol',   'carol@example.com',
     '$2a$10$abcdefghijklmnopqrstuv',
     'user', TRUE, now(), NULL,
     '555-000-0003', '', '{"theme":"light","notifications":{"email":false,"sms":true}}'::jsonb,
     now(), now()
    ),
    ('Dave',  'Patel',   'davep',   'dave@example.com',
     '$2a$10$abcdefghijklmnopqrstuv',
     'admin',TRUE, now(), NULL,
     '555-000-0004', '', '{"theme":"dark","notifications":{"email":true,"sms":false}}'::jsonb,
     now(), now()
    ),
    ('Eve',   'Wong',    'evew',    'eve@example.com',
     '$2a$10$abcdefghijklmnopqrstuv',
     'user', TRUE, now(), NULL,
     '555-000-0005', '', '{"theme":"light","notifications":{"email":true,"sms":true}}'::jsonb,
     now(), now()
    );
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DELETE FROM users
WHERE username IN ('alice','bobby','carol','davep','evew');
-- +goose StatementEnd
