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
);

-- ===============
-- 4.cast TRIGGERY
-- ===============

-- trigger #1
-- U vytvoření záznamu borrow musí být uvedena dvě id, jedno zákazníka, jedno zaměstance.
-- Trigger ověří, zda každé z nich skutečně patří odpovídající osobě (tj. že employee_id patří osobě,
-- která je zaměstnancem, a customer_id osobě, která je vedena jako zákazník)
create or replace trigger check_borrow_personel
    before insert on borrow
    for each row
declare
    is_employee person.is_employee%type;
    is_customer person.is_customer%type;
begin
    select person.is_employee
    into is_employee
    from person where person.person_id = :new.employee_id;

    select person.is_customer
    into is_customer
    from person where person.person_id = :new.customer_id;

    if
        (is_employee = 0)
    then
        raise_application_error(-20250, 'Not employee id, couldnt lend copy to customer');
    end if;

    if
        (is_customer = 0)
    then
        raise_application_error(-20250, 'Not customer id, couldnt lend copy to someone whos not customer');
    end if;

end;

-- trigger #2
-- TODO Denis
-- vytvoření jednoho netriviálního databázového triggeru vč. jeho předvedení (to můžeš buď tu nebo až pod inserty,
-- podle toho, na co to bude trigger), z toho právě jeden trigger pro automatické generování hodnot primárního klíče
-- nějaké tabulky ze sekvence (např. pokud bude při vkládání záznamů do dané tabulky hodnota primárního klíče
-- nedefinována, tj. NULL)
-- pravděpodobně budeš pro toto muset změnit jak vypadá table (bez auto generovaného klíče) a pozměnit tím pádem i
-- některé inserty změnit k tomu



-- ===================================
--   2. cast INSERT
-- ===================================
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
insert into borrow(title_id, copy_id, borrow_date, return_date, price, customer_id, employee_id)
values(12,12, TO_DATE('23/12/2020', 'DD/MM/YYYY'), NULL, NULL, 5, 1);

-- kontroni vypisy pro prvni cast
-- treti cast vymazana, lze najit v predchozich ukolech
/*
SELECT * from title;
SELECT * from copy;
SELECT * from genre;
SELECT * from person;
SELECT * from borrow;
*/

-- ===========================================================
--                          4. cast
-- ===========================================================

-- TRIGGERs demonstrace
-- Trigger #1
-- Insert do tabulky borrow, který skončí chybou. Je to kvůli tomu, že ID 1 je osoba
-- vystupující pouze jako zaměstnanec, nemůže být uvedena jako zákazník (customer_id) u výpůjčky
insert into borrow(title_id, copy_id, borrow_date, return_date, price, customer_id, employee_id)
values(11,11, TO_DATE('18/12/2020', 'DD/MM/YYYY'), TO_DATE('19/12/2020', 'DD/MM/YYYY'),  30, 1, 2);

-- PROCEDUREs
-- Procedura #1
-- Spočítá kolik videopůjčovna vlastní kopií (kazet), kolik z nich je
-- je zapůjčených, kolik volných a kolik procent kopií je zapůjčených
-- (např. jako přehledný indikátor, jak je prodejna vytížená a kolik
-- svého potenciálu může zákazníkům právě nabídnout)
-- Obsahuje ošetření (exception) dělení nulou.
create or replace procedure count_copies_state
as
    free_copies number;
    borrowed_copies number;
    total_copies number;
    percentage_borrowed number;
begin
    select count(*) into total_copies from copy;
    select count(*) into borrowed_copies from borrow where borrow.return_date is NULL;
    free_copies := total_copies - borrowed_copies;
    percentage_borrowed := 100 * borrowed_copies / total_copies;

    DBMS_OUTPUT.put_line('Shop has total of ' || total_copies);
    DBMS_OUTPUT.put_line('Borrowed: ' || borrowed_copies);
    DBMS_OUTPUT.put_line('Free: ' || free_copies);
    DBMS_OUTPUT.put_line('Percentage borrowed: ' || percentage_borrowed || '%');

    exception when zero_divide then
    begin
        DBMS_OUTPUT.put_line('Shop has total of ' || total_copies);
        DBMS_OUTPUT.put_line('Borrowed: ' || borrowed_copies);
        DBMS_OUTPUT.put_line('Free: ' || free_copies);
        DBMS_OUTPUT.put_line('Percentage borrowed: 0%');
    end;
end;

-- Spuštění první procedury, vypíše aktuální stav kopií
begin count_copies_state(); end;

-- Procedura #2
-- využívající kurzor a proměnnou s datovým typem odkazujícím se na řádek či typ sloupce tabulky
-- Procedura vyžaduje jako parametr název žánru. Projde veškeré uzavřené zápůjčky a spočítá celkové výdělky,
-- výdělky titlů v tomto žánru a kolik procent výdělků patří zadanému žánru.
create or replace procedure count_genre_profit (desired_genre_name in varchar) as
begin
    declare cursor cursor_borrow is
        SELECT borrow.price, title.genre
        from borrow
        join title on borrow.title_id = title.title_id
        where borrow.price is not NULL;
    g_price borrow.price%TYPE;
    g_name title.genre%TYPE;
    total_price number;
    desired_price number;
    percent_profit number;
    begin
        total_price := 0;
        desired_price := 0;
        open cursor_borrow;
        loop
            fetch cursor_borrow into g_price, g_name;
            exit when cursor_borrow%notfound;
            if g_name = desired_genre_name then
                desired_price := desired_price + g_price;
            end if;
            total_price := total_price + g_price;
        end loop;
        close cursor_borrow;
        dbms_output.put_line('Total profit: ' || total_price);
        dbms_output.put_line(desired_genre_name || ' profit: ' || desired_price);
        if total_price != 0 then
            percent_profit := 100 * desired_price / total_price;
            dbms_output.put_line('Relative genre profit: (in % of total profit) ' || percent_profit);
        end if;
    end;
end;

-- Demonstrace procedury #2, vypíše informace o profitu pro žánr komedie
begin count_genre_profit('comedy'); end;

-- EXPLAIN plan
-- dotaz prohledá kopie seskupené podle žánru a vybere pouze ten žánr, kde existuje
-- více než 1 kopie (kazeta)
explain plan for
SELECT genre.name
from genre
where genre.name in(
    SELECT title.genre
    from copy
    join title on title.title_id = copy.title_id
    group by title.genre
    having COUNT(copy.copy_id) > 1
    );

-- Demonstrace Explain plan bez optimalizace indexem
-- Součástí je vyhledání kopie daného titulu (kvůli příslušnosti k žánru), kde
-- kvůli join těchto dvou tabulek probíhají další operace. Toto by šlo zoptimalizovat zavedením
-- indexu.
select * from table (DBMS_XPLAN.DISPLAY());

-- Vytvoření indexu u kopie na titul (místo prohledávání tabulky a nalezení titulu s daným id
-- je zde tak index).
create index title_copy on copy(title_id);

-- Opětovné zavolání explain plan nad stejným dotazem.
explain plan for
SELECT genre.name
from genre
where genre.name in(
    SELECT title.genre
    from copy
    join title on title.title_id = copy.title_id
    group by title.genre
    having COUNT(copy.copy_id) > 1
    );

-- Demonstrace výsledku. Je použit index vytvořený výše, díky kterému se počet operací zmenšil na 7 (z 9).
select * from table (DBMS_XPLAN.DISPLAY());

-- TODO Denis
-- Vytvořit alespoň jeden materializovaný pohled patřící druhému členu týmu (aka dole v todo dáš řádek na grant práva afaik)
-- a používající tabulky definované prvním členem týmu

-- Předání práv druhému členu týmu
grant all on title to xlebod00;
grant all on copy to xlebod00;
grant all on genre to xlebod00;
grant all on person to xlebod00;
grant all on borrow to xlebod00;

grant execute on count_copies_state to xlebod00;
grant execute on count_genre_profit to xlebod00;
-- TODO doplnit
-- grant all on materialized_view_name to xlebod00;