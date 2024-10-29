-- create db
CREATE DATABASE testdb;

-- delete db:
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'testdb'
AND pid <> pg_backend_pid()
DROP DATABASE testdb

-- create tables:
CREATE TABLE publisher
(
    pk_publisher_id integer PRIMARY KEY,
	org_name varchar(128) NOT NULL,
	address text NOT NULL
);

CREATE TABLE book
(
    book_id integer PRIMARY KEY,
	title text NOT NULL,
	isbn varchar(32) NOT NULL,
	fk_publisher_id integer REFERENCES publisher(pk_publisher_id) NOT NULL
)

-- delete table:
DROP TABLE publisher;

-- inset values to db tables:
INSERT INTO book
VALUES
(1, 'The Diary of a Young Girl', '0199535566', 1),
(2, 'Pride and Prejudice', '9780307594006', 1),
(3, 'To kill a Mockingbird', '0446310786', 2),
(4, 'The Book of Gutsy Women: Favorite Stories of Courage and Resilience', '1501178415', 2),
(5, 'War and Peace', '1788886526', 2);

INSERT INTO publisher
VALUES
(1, 'Everyman''s Library', 'NY'),
(2, 'Oxford University Press', 'NY'),
(3, 'Grand Central Publishing', 'Washington'),
(4, 'Simon & Schuster', 'Chicago');


-- to see data in table:
SELECT *
FROM book

-- add new in table:
ALTER TABLE book
ADD COLUMN fk_publisher_id;

ALTER TABLE book
ADD CONSTRAINT fk_book_publisher
FOREIGN KEY(fk_publisher_id) REFERENCES publisher(pk_publisher_id);

-- 1 to 1 relation:
CREATE TABLE person
(
	pk_person_id int PRIMARY KEY,
	first_name varchar(64) NOT NULL,
	last_name varchar(64) NOT NULL
);

CREATE TABLE passport
(
	pk_passport_id int PRIMARY KEY,
	serial_number int NOT NULL,
	fk_passport_person int REFERENCES person(pk_person_id)
);

INSERT INTO person VALUES (1, 'John', 'Snow');
INSERT INTO person VALUES (2, 'Ned', 'Stark');
INSERT INTO person VALUES (3, 'Rob', 'Baratheon');

ALTER TABLE passport
ADD COLUMN registration text NOT NULL;

INSERT INTO passport VALUES (1, 123456, 1, 'Winterfell');
INSERT INTO passport VALUES (2, 789012, 2, 'Winterfell');
INSERT INTO passport VALUES (3, 345678, 3, 'King''s Landing');

-- many-to-many relation:
DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS author;

CREATE TABLE book
(
    book_id integer PRIMARY KEY,
	title text NOT NULL,
	isbn varchar(32) NOT NULL
);

CREATE TABLE author
(
    author_id int PRIMARY KEY,
	full_name text NOT NULL,
	rating real
);

CREATE TABLE book_author
(
	book_id int REFERENCES book(book_id),
	author_id int REFERENCES author(author_id),
	CONSTRAINT book_author_pk PRIMARY KEY(book_id, author_id) --composite key
);

INSERT INTO book
values
	(1, 'Book for Dummies', '123456'),
	(2, 'Book for Smart Guys', '7890123'),
	(3, 'Book for Happy People', '456789'),
	(4, 'Book for Unhappy People', '1234567');

INSERT INTO author
values
	(1, 'Bob', 4.6),
	(2, 'Alice', 4.0),
	(3, 'John', 5.0);

INSERT INTO book_author
values
	(1, 1),
	(2, 1),
	(3, 1),
	(3, 2),
	(4, 1),
	(4, 2),
	(4, 3)
