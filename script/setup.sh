#!/bin/sh

if ! carton --version > /dev/null 2>&1; then
    echo 'install Carton ...'
    cpanm Carton
fi

if ! mysql -uroot -e 'use prepan' > /dev/null 2>&1; then
    echo 'setup prepan db ...'
    mysql -uroot -e 'CREATE DATABASE prepan'
    mysql -uroot prepan < db/schema.sql
fi

if ! mysql -uroot -e 'use qudo' > /dev/null 2>&1; then
    echo 'setup qudo db ...'
    carton exec -- qudo --db=qudo --user=root --rdbms=mysql --use_innodb
fi

if ! mysql -uroot -e 'use prepan_test' > /dev/null 2>&1; then
    mysql -uroot -e 'CREATE DATABASE prepan_test'
    echo 'setup prepan_test db ...'
    mysql -uroot prepan_test < db/schema.sql
fi

if ! mysql -uroot -e 'use qudo_test' > /dev/null 2>&1; then
    echo 'setup qudo_test db ...'
    carton exec -- qudo --db=qudo_test --user=root --rdbms=mysql --use_innodb
fi
