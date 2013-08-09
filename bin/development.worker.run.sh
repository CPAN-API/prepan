#!/bin/sh

exec 2>&1
export PATH=/usr/local/perl-prepan/bin:$PATH
export PLACK_ENV=development
export PREPAN_ENV=development
export APPROOT=/var/www/prepan
cd $APPROOT || exit 1

exec setuidgid deployer carton exec -- script/worker.pl
