-- autori: xstrna14, xlebod00
-- zadani: 24 Videopujcovna

drop table something;
drop table something2;

create table something
(
	value int generated as identity
		constraint something_pk
			primary key,
	name varchar(100)
);
create table something2
(
	value int generated as identity
		constraint something2_pk
			primary key,
	name varchar(100)
);
INSERT INTO something (name)
VALUES ('hello');
INSERT INTO something (name)
VALUES ('hello');

SELECT * from something;