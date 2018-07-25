cd /data0/src/php-5.6.30/ext/pdo_mysql/
/usr/local/php/bin/phpize
./configure -with-php-config=/usr/local/php/bin/php-config
make && make install

cd /data0/src/php-5.6.30/ext/mysqli/
/usr/local/php/bin/phpize
./configure -with-php-config=/usr/local/php/bin/php-config
make && make install
