#!/bin/bash

LIQUIBASE_HOME=/mnt/d/liquibase-3.9.0
POSTGRESQL_DRIVER=/mnt/d/lib/postgresql-42.2.18.jar
${LIQUIBASE_HOME}/liquibase --changeLogFile=00000-database.sql --url=jdbc:postgresql://localhost:5432/postgres --username=postgres --password=postgres --classpath=${POSTGRESQL_DRIVER} --logLevel INFO update
${LIQUIBASE_HOME}/liquibase --changeLogFile=00000-initial.sql --url=jdbc:postgresql://localhost:5432/catalog --username=catalog --password=catalog --classpath=${POSTGRESQL_DRIVER} --logLevel INFO update
${LIQUIBASE_HOME}/liquibase --changeLogFile=00001-count_history.sql --url=jdbc:postgresql://localhost:5432/catalog --username=catalog --password=catalog --classpath=${POSTGRESQL_DRIVER} --logLevel INFO update
${LIQUIBASE_HOME}/liquibase --changeLogFile=00002-rate_fix.sql --url=jdbc:postgresql://localhost:5432/catalog --username=catalog --password=catalog --classpath=${POSTGRESQL_DRIVER} --logLevel INFO update
