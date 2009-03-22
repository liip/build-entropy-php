#!/bin/sh
# 
# Figure out if another PHP module is already active before
# attempting to install the Entropy PHP distribution.
#
# Exits with exit code
# - 0 (true) if another module is active
# - 1 (false) otherwise
#

if sw_vers -productName | grep -qi server; then
	SYMLINK=/etc/apache2/sites/+entropy-php.conf
else
	SYMLINK=/etc/apache2/other/+entropy-php.conf
fi

TARGET=$(readlink $SYMLINK)

if [ "$TARGET" ]; then
	echo temporarily deactivating entropy PHP conf
	rm $SYMLINK
fi

/usr/sbin/httpd -M 2>&1 | grep -q php5_module
RESULT=$?
echo $RESULT > /tmp/entropy-check_for_activated_php_result

if [ "$TARGET" ]; then
	echo restoring entropy PHP conf
	ln -s "$TARGET" $SYMLINK
fi

exit $RESULT
