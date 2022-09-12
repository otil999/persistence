#!/bin/bash
/mnt/project/liquibase-4.10.0/liquibase --changeLogFile=$1 --url=jdbc:postgresql://localhost:5432/catalog --username=catalog --password=catalog --classpath=/mnt/project/mvn_repo/org/postgresql/postgresql/42.2.18.jre7/postgresql-42.2.18.jre7.jar --logLevel INFO update
