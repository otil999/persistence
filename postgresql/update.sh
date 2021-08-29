#!/bin/bash
/media/project/liquibase-4.3.1/liquibase --changeLogFile=$1 --url=jdbc:postgresql://localhost:5432/catalog --username=catalog --password=catalog --classpath=/media/project/mvn_repo/org/postgresql/postgresql/42.2.18.jre7/postgresql-42.2.18.jre7.jar --logLevel INFO update
