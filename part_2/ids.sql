-- autori: xstrna14, xlebod00
-- zadani: 24 Videopujcovna

-- drop predchozich tabulek, pro testovaci ucely
--TODO comment

drop table title;
drop table copy;

-- create
create table title
(
	title_id int generated as identity
		constraint title_pk
			primary key,
	name varchar(50) not null,
	year int not null,
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








-- INSERT
-- naplneni tabulek vzorovymi daty

INSERT INTO title (name, year, price_per_day)
VALUES ('Vecny pribeh', 1980, 50);
INSERT INTO title (name, year, price_per_day)
VALUES ('Vecny pribeh', 1990, 50);
insert into copy (title_id)
values(1);


-- kontroni vypisy, TODO vymazat
SELECT * from title;
SELECT * from copy;