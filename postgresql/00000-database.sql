--liquibase formatted sql

--changeset otil:database runInTransaction:false
CREATE DATABASE catalog ENCODING 'UNICODE';

--changeset otil:role
CREATE ROLE catalog LOGIN PASSWORD 'catalog';
