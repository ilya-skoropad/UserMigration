-- +goose Up
-- +goose StatementBegin
CREATE SCHEMA app;

CREATE TABLE "app"."role" (
    "id" INT PRIMARY KEY,
    "name" CHAR(20)
);

CREATE TABLE "app"."state" (
    "id" INT PRIMARY KEY,
    "name" CHAR(20)
);

CREATE TABLE "app"."user" (
    "guid"          UUID PRIMARY KEY NOT NULL DEFAULT GEN_RANDOM_UUID(),
    "state_id"      INT NOT NULL REFERENCES "app"."state"("id"),
    "role_id"       INT NOT NULL REFERENCES "app"."role"("id"),
    "nickname"      VARCHAR(255) NOT NULL,
    "login"         CHAR(25)     NOT NULL,
    "email"         VARCHAR(255) NOT NULL,
    "password"      CHAR(255)    NOT NULL,
    "created_at"    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    "activation_key" CHAR(20)    NULL,
    "activated_at " TIMESTAMPTZ  NULL,
    "last_login_at" TIMESTAMPTZ  NULL
);

INSERT INTO "app"."role"("id", "name")
VALUES (1, 'admin'),
       (2, 'user');

INSERT INTO "app"."state"("id", "name")
VALUES (0, 'inactive'),
       (1, 'active');

CREATE ROLE api LOGIN;

GRANT SELECT, INSERT, UPDATE ON "app"."role" TO api;
GRANT SELECT, INSERT, UPDATE ON "app"."state" TO api;
GRANT SELECT, INSERT, UPDATE ON "app"."user" TO api;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP SCHEMA "app" CASCADE;
DROP ROLE api
-- +goose StatementEnd
