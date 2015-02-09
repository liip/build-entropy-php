#!/bin/sh
export YACC="/usr/local/Cellar/bison/3.0.2/bin/bison -y"
rm -rf /tmp/build-entropy-php-pkg/php5/ /tmp/build-entropy-php-pkgdst/entropy-php.pkg
nice -n 19 perl -Ilib build-php.pl && git diff
