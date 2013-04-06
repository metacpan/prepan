#!/bin/sh

echo 'setup prepan db ... '
mysql -uroot -e 'DROP DATABASE IF EXISTS prepan; CREATE DATABASE prepan'
mysql -uroot prepan < db/schema.sql
mysql -uroot -e 'DROP DATABASE IF EXISTS qudo;'
carton exec -- qudo --db=qudo --user=root --rdbms=mysql --use_innodb

echo 'setup prepan_test db ... '
mysql -uroot -e 'DROP DATABASE IF EXISTS prepan; CREATE DATABASE prepan_test'
mysql -uroot prepan_test < db/schema.sql
mysql -uroot -e 'DROP DATABASE IF EXISTS qudo_test;'
carton exec -- qudo --db=qudo_test --user=root --rdbms=mysql --use_innodb
