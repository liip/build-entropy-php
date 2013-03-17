#!/bin/sh

rm -rf /tmp/build-entropy-php-pkg/php5/ /tmp/build-entropy-php-pkgdst/entropy-php.pkg
nice -n 19 perl5.10.0 -Ilib build-php.pl

git diff

