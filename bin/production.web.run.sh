#!/bin/sh

exec 2>&1
export PATH=/usr/local/perl-prepan/bin:$PATH
export PLACK_ENV=production
export PREPAN_ENV=production
export PREPAN_ACCESSLOG=/var/log/prepan/access.log
export APPROOT=/var/www/prepan
cd $APPROOT || exit 1

exec setuidgid deployer carton exec -- \
     starman --port 8000 --workers=5 app.psgi
