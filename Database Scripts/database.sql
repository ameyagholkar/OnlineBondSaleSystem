create database blb;

use blb;

create table bonds(
	cusip varchar(256) not null, /* eg MSFT */
	rating varchar(16),
	coupon_rate double not null,
	current_yield double not null,
	maturity_yield double not null,
	maturity_date date,
	par_value double not null,
	price double not null,
	group_id integer not null, /* only a group can hold an ownership */
	quantity_owned integer not null /* quantity owned by an owner_id customer */
);

create table traders(
id integer primary key,
username varchar(64) not null,
password_hash varchar(32) not null
);

create table customers(
id integer primary key,
username varchar(64) not null,
password_hash varchar(32) not null,
trader_id integer not null,
balance double not null,
full_name varchar(512),
address  varchar(512),
phone varchar(128)
);

create table groups(
	id integer not null,
	group_type integer not null, /* 0 for group of traders, 1 otherwise */
	participant_id integer not null
);

create table transactions(
	id integer primary key not null,
	buyer_id integer not null, /* group_id */
	seller_id integer not null, /* group_id */
	trader_id integer not null, /* id of the trader who executed transaction */
	transaction_date datetime not null, /* curdate() */
	bond_cusip varchar(256) not null,
	quantity integer not null,
	transaction_status integer not null /* 0 - initiated, 1 - pending, 2 - completed, 3 - cancelled */
);

create table log (
	login_date datetime not null,
	username varchar(64) not null
);

create table login_session(
	session_id varchar(32) not null primary key,
	username varchar(64) not null,
	last_activity datetime not null
);

alter table bonds add column bond_name varchar(256);
alter table bonds add column issuer_name varchar(256);
alter table bonds change column cusip cusip varchar(9);
alter table bonds add column bond_type varchar(32); /* public vs government */
alter table bonds change column bond_type bond_type integer; /* 0 - Government, 1- Corporate*/

insert into traders values (1, "AnshuJain", "anshu");
insert into traders values (2, "BradPitt", "brad");
insert into traders values (3, "HenryRitchotte", "henry");
insert into traders values (4, "CarlsJunior", "carls");
insert into traders values (5, "JimmyChoo", "jimmy");

insert into customers values (1, "KanikaBansal", "kanika",1, 200, "Kanika Bansal", "1 Park Lane", "0744835463");
insert into customers values (2, "AlexeyMoroz", "alexey",2, 2000, "Alexey Moroz", "1 Borough Lane", "0742335463");
insert into customers values (3, "PhoebeBuffay", "phoebe",1, 300, "Phoebe Buffay", "5 Park Lane", "0744812363");
insert into customers values (4, "MikeMoore", "mike",3, 500, "Mike Moore", "1 Park Street", "0723675463");
insert into customers values (5, "JohnSmith", "john",1, 2600, "John Smith", "10 Downing Street", "0744835178");

insert into groups values (1, 0, 1);
insert into groups values (1, 0, 2);
insert into groups values (2, 1, 1);
insert into groups values (2, 1, 3);
insert into groups values (3, 0, 3);
insert into groups values (4, 0, 4);
insert into groups values (5, 0, 5);
insert into groups values (6, 1, 2);
insert into groups values (7, 1, 4);
insert into groups values (8, 1, 5);

insert into bonds values ("0088a4567", "AAA", 10.00, 4.00, 3.50, '2018-7-04', 100, 123, 2, 10, "Microsoft", "Microsoft", 1),
("0088a4573", "AAA", 10.00, 5.00, 3.50, '2018-2-04', 100, 103, 6, 10, "Google", "Google", 1),
("0008a4527", "AAA", 11.00, 4.00, 3.50, '2015-7-14', 100, 146, 7, 20, "Gilt", "UK Government", 0),
("0008a4527", "AAA", 11.00, 4.00, 3.50, '2015-7-14', 100, 145, 8, 30, "Gilt", "UK Government", 0);