CREATE SEQUENCE IF NOT EXISTS customer_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1;

CREATE TABLE IF NOT EXISTS customer (
	id integer NOT NULL DEFAULT nextval('customer_id_seq'),
	last_name varchar(100) NULL,
	first_name varchar(100) NULL,
	city varchar(100) NULL,
    active bool DEFAULT 't',
    category integer NOT NULL DEFAULT 1,
	created timestamp NULL DEFAULT now(),
	CONSTRAINT customer_pkey PRIMARY KEY (id)
);