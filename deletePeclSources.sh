for i in `find src -name config.nice -maxdepth 4`
do
echo `dirname $i`
rm -rf `dirname $i`
done


for i in `ls -d src/xhprof*`
do
echo  $i
rm -rf $i
done

for i in `ls -d src/php-*`
do
echo  $i
rm -rf $i
done

rm ~/.pearrc

rm /usr/local/php5/libphp5.so
rm -rf /usr/local/php5/lib/php
rm -rf /usr/local/php5/php.d/
rm -rf /usr/local/php/bin/php*

