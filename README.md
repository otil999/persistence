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
