create role psqluser with login;
CREATE ROLE vault WITH LOGIN SUPERUSER PASSWORD '123456';

create database my_db_1 with owner vault1;

\c my_db_1 psqluser;

create table table1(
    tag_name varchar(32),
    tag_value text
);


insert into table1 (tag_name, tag_value) values('Hello', 'Postgresql');
insert into table1 (tag_name, tag_value) values('Hello1', 'Postgresql1');
insert into table1 (tag_name, tag_value) values('Hello2', 'Postgresql2');
insert into table1 (tag_name, tag_value) values('Hello3', 'Postgresql3');
insert into table1 (tag_name, tag_value) values('Hello4', 'Postgresql4');