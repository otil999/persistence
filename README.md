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
* docker run -t -i -d --name catalog_pg11 -e POSTGRES_PASSWORD=postgres -p 5432:5432 -v /media/devel/catalog_data/pgdata11:/var/lib/postgresql/data postgres:11
* run database.sql to set up catalog database
* run roles.sql to set up catalog role
* run ddl.sql
* run patchXXXX.sql in numeric order
