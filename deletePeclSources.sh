for i in `find src -name config.nice -maxdepth 2` 
do
echo `dirname $i`
rm -rf `dirname $i`
done


for i in `ls -d src/xhprof*`
do
echo  $i
rm -rf $i
done
