-- autori: xstrna14, xlebod00
-- zadani: 24 Videopujcovna

-- drop predchozich tabulek, pro testovaci ucely
--TODO comment

drop table title cascade constraints;
drop table copy cascade constraints;
drop table borrow cascade constraints;
drop table genre cascade constraints;
drop table person cascade constraints;

-- create
create table genre
(
    name varchar(50) not null
        constraint genre_pk
            primary key
);
create table title
(
	title_id int generated as identity
		constraint title_pk
			primary key,
	name varchar(50) not null,
	year int not null,
	genre varchar(50) not null,
	constraint genre_fk
	    foreign key (genre) references genre(name),
	price_per_day float not null
);
create table copy
(
	copy_id int generated as identity,
	title_id int not null,
	constraint copy_pk
		primary key (copy_id, title_id),
	constraint copy_title_fk
		foreign key (title_id) references title (title_id)
);
create table person
(
	person_id int generated as identity
		constraint person_pk
			primary key,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	house_number int not null,
	street varchar(50) not null,
	town varchar(50) not null,
	zip_code int not null,
	is_employee number default 0,
	is_customer number default 0,
	constraint zip_check
		check (regexp_like(zip_code, '^\d{5}$')),
	constraint person_is_something
        check (is_customer = 1 OR is_employee = 1),

);

create table borrow
(
    borrow_id int generated as identity
        constraint borrow_pk
            primary key,
    borrow_date date not null,
    return_date date,
    price float,
    customer_id int not null, --borrowed title
    employee_id int not null, -- checked it out
    constraint customer_id_fk
        foreign key (customer_id) references person(person_id),
    constraint employee_id_fk
        foreign key (employee_id) references person(person_id)
    --TODO constraint user is user and empl is empl
);

-- dodatecna omezeni



-- INSERT
-- naplneni tabulek vzorovymi daty

insert into genre (name)
values ('romance');
insert into genre (name)
values ('thriller');

INSERT INTO title (name, year, genre, price_per_day)
VALUES ('Vecny pribeh', 1980, 'romance', 50);
INSERT INTO title (name, year, genre, price_per_day)
VALUES ('Vecny pribeh', 1990, 'thriller', 50);
insert into copy (title_id)
values(1);

insert into person(first_name, last_name, house_number, street, town, zip_code, is_employee, is_customer)
values ('Jiri', 'Novak', 58, 'Netinska', 'Brno', 58000, 1, 0);
insert into person(first_name, last_name, house_number, street, town, zip_code, is_employee, is_customer)
values ('Eva', 'Novotna', 240, 'Brnenska', 'Boskovice', 54110, 0, 0);


-- kontroni vypisy, TODO vymazat
SELECT * from title;
SELECT * from copy;
SELECT * from genre;
SELECT * from person;
SELECT * from borrow;