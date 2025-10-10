-- +goose Up
-- +goose StatementBegin
create schema app;

create table app.role (
    id int primary key,
    name char(20)
);

create table app.state (
    id int primary key,
    name char(20)
);

create table app.user (
    guid          uuid primary key not null default gen_random_uuid(),
    state_id      int not null references app.state(id),
    role_id       int not null references app.role(id),
    nickname      varchar(255) not null,
    login         char(25)     not null,
    email         varchar(255) not null,
    password      char(255)    not null,
    created_at    timestamptz  not null default now(),
    activation_key char(30)    null,
    activated_at  timestamptz  null,
    updated_at    timestamptz  null,
    last_login_at timestamptz  null
);

create unique index idx_user_login on app.user (login);
create unique index idx_user_email on app.user (email);
create unique index idx_user_activation_key on app.user (activation_key);

insert into app.role(id, name)
values (1, 'admin'),
       (2, 'user');

insert into app.state(id, name)
values (0, 'deleted'),
       (1, 'active');

create role api;

grant usage on schema app to api;
grant select on app.role to api;
grant select on app.state to api;
grant select, insert, update on app.user to api;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
drop schema app cascade;
drop role api cascade
-- +goose StatementEnd
