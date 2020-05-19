#!/bin/bash

/media/project/liquibase-3.9.0/liquibase --changeLogFile=00000-database.sql --url=jdbc:postgresql://localhost:5432/postgres --username=postgres --password=postgres --classpath=/media/temp/software_store/development/postgresql-42.2.12.jar --logLevel INFO update
/media/project/liquibase-3.9.0/liquibase --changeLogFile=00000-initial.sql --url=jdbc:postgresql://localhost:5432/catalog --username=catalog --password=catalog --classpath=/media/temp/software_store/development/postgresql-42.2.12.jar --logLevel INFO update
/media/project/liquibase-3.9.0/liquibase --changeLogFile=00001-count_history.sql --url=jdbc:postgresql://localhost:5432/catalog --username=catalog --password=catalog --classpath=/media/temp/software_store/development/postgresql-42.2.12.jar --logLevel INFO update
