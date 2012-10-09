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