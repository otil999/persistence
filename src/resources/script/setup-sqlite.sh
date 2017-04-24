#!/bin/bash

DATABASE=catalog_test.sqlite

if [ -f ${DATABASE} ]; then
    echo "Removing old database."
    rm ${DATABASE}
fi
echo "Setting up catalog database."
echo '.quit' | sqlite3 --batch --init ../sqlite/ddl.sql ${DATABASE}
echo '.quit' | sqlite3 --batch --init ../sqlite/dml.sql ${DATABASE}
