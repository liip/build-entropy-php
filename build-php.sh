#!/bin/sh

export PHP_AUTOCONF=$PWD/extras/autoconf2.13/bin/autoconf 
export PHP_AUTOHEADER=$PWD/extras/autoconf2.13/bin/autoheader 
rm -rf /tmp/build-entropy-php-pkg/php5/ /tmp/build-entropy-php-pkgdst/entropy-php.pkg
nice -n 19 perl -Ilib build-php.pl
