--DROP KEYSPACE catalog;
CREATE KEYSPACE catalog WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 2};

USE catalog;

CREATE TABLE media (
	name text,
	PRIMARY KEY (name)
);
