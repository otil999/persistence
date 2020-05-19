SQL files for catalog
--
To setup the sqlite based database:
* run script/setup-sqlite.sh: creates a new test databases (removes the old one if
  exists) and runs DDL and DML code on it.

How to export tables from old database:
 sqlite3 catalog.sqlite
 .mode insert
 .output series.sql
 select * from series order by series_id;

How to setup a PostgreSQL docker base databased for catalog:
* docker run -ti -d --rm --name catalog_pg11 -e POSTGRES_PASSWORD=postgres -p 5432:5432 -v /media/devel/catalog_data/pgdata11:/var/lib/postgresql/data postgres:11
* liquibase --changeLogFile=database.sql --url=jdbc:postgresql://localhost:5432/postgres --username=postgres --password=postgres --classpath=.:postgresql-42.2.12.jar --logLevel INFO update
