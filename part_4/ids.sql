-- autori: xstrna14, xlebod00
-- zadani: 24 Videopujcovna

-- drop predchozich tabulek, pro testovaci ucely

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
        check (is_customer = 1 OR is_employee = 1)
);

create table borrow
(
    borrow_id int generated as identity
        constraint borrow_pk
            primary key,
    title_id int not null,
    copy_id int not null,
    borrow_date date not null,
    return_date date,
    price float,
    customer_id int not null, --borrowed title
    employee_id int not null, -- checked it out
    constraint title_copy_id_fk
        foreign key (title_id, copy_id) references copy(title_id, copy_id),
    constraint customer_id_fk
        foreign key (customer_id) references person(person_id),
    constraint employee_id_fk
        foreign key (employee_id) references person(person_id)
    /*
     Kvuli omezenym moznostem SQL na generalizaci je z tohoto
     mista obtizne overit, zda dane id nalezi uzivateli. Toto overeni
     bychom nechali na aplikaci, ktera nad timto pracuje.
     Vyuzila by k tomu priznaky is_employee a is_customer
     v tabulce "person".
     */
);

-- INSERT
-- naplneni tabulek vzorovymi daty

insert into genre (name)
values ('comedy');
insert into genre (name)
values ('sci-fi');
insert into genre(name)
values('horror');
insert into genre(name)
values('romance');
insert into genre(name)
values('action');
insert into genre(name)
values('thriller');
insert into genre(name)
values('drama');
insert into genre(name)
values('mystery');
insert into genre(name)
values('crime');
insert into genre(name)
values('animation');
insert into genre(name)
values('fantasy');

insert into title (name, year, genre, price_per_day)
values ('Life of Brian', 1979, 'comedy', 25);
insert into title (name, year, genre, price_per_day)
values ('Martian', 2015, 'sci-fi', 45);
insert into title (name, year, genre, price_per_day)
values ('Saw 2', 2005, 'horror', 35);
insert into title (name, year, genre, price_per_day)
values ('Bridget Jones Diary', 2001, 'romance', 30);
insert into title (name, year, genre, price_per_day)
values ('Avengers: End Game', 2019, 'action', 50);
insert into title (name, year, genre, price_per_day)
values ('Quantum of Solace', 2008, 'action', 35);
insert into title (name, year, genre, price_per_day)
values ('Train to Busan', 2016, 'thriller', 50);
insert into title (name, year, genre, price_per_day)
values ('Parasite', 2019, 'drama', 50);
insert into title (name, year, genre, price_per_day)
values ('Se7en', 1995, 'mystery', 25);
insert into title (name, year, genre, price_per_day)
values ('The Godfather', 1972, 'crime', 25);
insert into title (name, year, genre, price_per_day)
values ('Spirited Away', 2001, 'animation', 30);
insert into title (name, year, genre, price_per_day)
values ('Lord of the Rings: Return of the King', 2003, 'fantasy', 30);
insert into title (name, year, genre, price_per_day)
values ('Lord of the Rings: Two Towers, 2002', 2002, 'fantasy', 25);
insert into title (name, year, genre, price_per_day)
values ('Lord of the Rings: Fellowship of the Ring', 2001, 'fantasy', 20);

insert into copy (title_id)
values(1);
insert into copy (title_id)
values(1);
insert into copy (title_id)
values(2);
insert into copy (title_id)
values(4);
insert into copy (title_id)
values(5);
insert into copy (title_id)
values(6);
insert into copy (title_id)
values(7);
insert into copy (title_id)
values(8);
insert into copy (title_id)
values(9);
insert into copy (title_id)
values(10);
insert into copy (title_id)
values(11);
insert into copy (title_id)
values(12);
insert into copy (title_id)
values(12);
insert into copy (title_id)
values(13);
insert into copy (title_id)
values(14);

insert into person(first_name, last_name, house_number, street, town, zip_code, is_employee, is_customer)
values ('Denis', 'Bradaty', 88, 'Cezarova', 'Nove Zamky', 94002, 1, 0);
insert into person(first_name, last_name, house_number, street, town, zip_code, is_employee, is_customer)
values ('Iveta', 'Botova', 69, 'Purkynova', 'Brno', 58000, 1, 1);
insert into person(first_name, last_name, house_number, street, town, zip_code, is_employee, is_customer)
values ('Vojta', 'Novy', 69, 'Nerudova', 'Brno', 58000, 1, 0);
insert into person(first_name, last_name, house_number, street, town, zip_code, is_employee, is_customer)
values ('Jiri', 'Novak', 58, 'Netinska', 'Brno', 58000, 0, 1);
insert into person(first_name, last_name, house_number, street, town, zip_code, is_employee, is_customer)
values ('Eva', 'Novotna', 240, 'Brnenska', 'Boskovice', 54110, 0, 1);
insert into person(first_name, last_name, house_number, street, town, zip_code, is_employee, is_customer)
values ('Karel', 'Krajci', 75, 'Purkynova', 'Brno', 58000, 0, 1);
insert into person(first_name, last_name, house_number, street, town, zip_code, is_employee, is_customer)
values ('Jan', 'Novak', 240, 'Brnenska', 'Boskovice', 54110, 0, 1);
insert into person(first_name, last_name, house_number, street, town, zip_code, is_employee, is_customer)
values ('Norbert', 'Madar', 26, 'Lipova', 'Nove Zamky', 94002, 0, 1);
insert into person(first_name, last_name, house_number, street, town, zip_code, is_employee, is_customer)
values ('Filip', 'Dreper', 32, 'Francouzska', 'Ostrava', 70030, 0, 1);
insert into person(first_name, last_name, house_number, street, town, zip_code, is_employee, is_customer)
values ('Mazenka', 'Tmava', 42, 'Tmava', 'Brno', 58000, 0, 1);
insert into person(first_name, last_name, house_number, street, town, zip_code, is_employee, is_customer)
values ('Vojta', 'Stary', 2, 'Korunova', 'Kyjov', 69655, 0, 1);
insert into person(first_name, last_name, house_number, street, town, zip_code, is_employee, is_customer)
values ('Eva', 'Novotna', 85, 'Rybova', 'Praha', 10000, 0, 1);
insert into person(first_name, last_name, house_number, street, town, zip_code, is_employee, is_customer)
values ('Adam', 'Nicnedelajici', 17, 'Opustena', 'Brno', 58000, 1, 0);

insert into borrow(title_id, copy_id, borrow_date, return_date, price, customer_id, employee_id)
values(1,1, TO_DATE('17/12/2020', 'DD/MM/YYYY'), NULL, NULL, 4, 1);
insert into borrow(title_id, copy_id, borrow_date, return_date, price, customer_id, employee_id)
values(1,2, TO_DATE('15/12/2020', 'DD/MM/YYYY'), TO_DATE('16/12/2020', 'DD/MM/YYYY'), 25, 9, 2);
insert into borrow(title_id, copy_id, borrow_date, return_date, price, customer_id, employee_id)
values(1,2, TO_DATE('16/12/2020', 'DD/MM/YYYY'), TO_DATE('18/12/2020', 'DD/MM/YYYY'), 50, 8, 2);
insert into borrow(title_id, copy_id, borrow_date, return_date, price, customer_id, employee_id)
values(9,9, TO_DATE('15/12/2020', 'DD/MM/YYYY'), TO_DATE('18/12/2020', 'DD/MM/YYYY'),75, 10, 3);
insert into borrow(title_id, copy_id, borrow_date, return_date, price, customer_id, employee_id)
values(11,11, TO_DATE('18/12/2020', 'DD/MM/YYYY'), TO_DATE('19/12/2020', 'DD/MM/YYYY'),  30, 4, 2);

-- kontroni vypisy pro prvni cast
-- treti cast vymazana, lze najit v predchozich ukolech
/*
SELECT * from title;
SELECT * from copy;
SELECT * from genre;
SELECT * from person;
SELECT * from borrow;
*/

-- 4. cast
-- predani prav pro druheho clena tymu
grant all on title to xlebod00;
grant all on copy to xlebod00;
grant all on genre to xlebod00;
grant all on person to xlebod00;
grant all on borrow to xlebod00;

-- TODO doplnit
-- grant execute on executable_stuff to xlebod00;
-- grant all on materialized_view_name to xlebod00;