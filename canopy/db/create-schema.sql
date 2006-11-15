-- db/create-schema.sql
--
-- Creates the Schema for the filesystem size checker
-- This is a very simple structure

drop table archives;
drop table directories;
drop table users;

create table users (
  id      serial
          constraint users_id_nn not null
          constraint users_id_pk primary key,
  name    varchar(10)
          constraint users_name_nn not null
);

create index users_name_idx on users(name);

create table directories (
  id          bigserial
              constraint directories_id_nn not null
              constraint directories_id_pk primary key,
  server      varchar(50)
              constraint directories_server_nn not null,
-- We expect a very long path (just in case)
  path        varchar(8000)
              constraint directories_path_nn not null,
  filesize    bigint
              constraint directories_filesize_df default 0,
  user_id     integer
              constraint directories_users_id_fk references users(id),
  created_at  timestamptz
              constraint directories_created_at_nn not null
              constraint directories_created_at_df default now()
);

create index directories_server_path_idx on directories(server, path);

-- Table that holds archival data

create table archives (
  id            bigserial
                constraint archives_id_nn not null
                constraint archives_id_pk primary key,
  server        varchar(50)
                constraint archives_server_nn not null,
-- We expect a very long path (just in case)
  path          varchar(8000)
                constraint archives_path_nn not null,
  filesize      bigint
                constraint archives_filesize_df default 0,
  user_id       integer
                constraint archives_users_id_fk references users(id),
  original_time timestamptz
                constraint archives_original_time_nn not null,
  created_at    timestamptz
                constraint archives_created_at_nn not null
                constraint archives_created_at_df default now()
);

create index archives_server_idx on archives(server);
