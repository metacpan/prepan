mysql -e 'CREATE DATABASE prepan_test'
mysql prepan_test < db/schema.sql

carton exec -- qudo --db=qudo_test --user=travis --rdbms=mysql --use_innodb
