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
