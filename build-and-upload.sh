set -e

bash deletePeclSources.sh
bash build-php.sh
cd ../php-osx
bash create_package.sh

