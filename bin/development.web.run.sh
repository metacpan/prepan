#!/bin/sh

exec 2>&1
export PATH=/usr/local/bin/perl-5.16.3/bin:$PATH
export PLACK_ENV=development
export PREPAN_ENV=development
export APPROOT=/var/www/prepan
cd $APPROOT || exit 1

exec setuidgid deployer carton exec -- \
     starman --port 8080 --workers=5 app.psgi
