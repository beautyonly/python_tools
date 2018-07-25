#!/bin/env bash

install_plugins(){
wget http://localhost:8080/jnlpJars/jenkins-cli.jar
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin checkstyle cloverphp crap4j dry htmlpublisher jdepend plot pmd violations warnings xunit
java -jar jenkins-cli.jar -s http://localhost:8080 safe-restart
}

install_php_tools(){
php_tools="
phpcpd
phploc
phpunit
"

for i in $php_tools
do
  wget https://phar.phpunit.de/${i}.phar
  install ${i}.phar /usr/bin/${i}
  ${i} --version
done

wget http://phpdox.de/releases/phpdox.phar
install phpdox.phar /usr/bin/phpdox
phpdox --version

wget -c http://static.phpmd.org/php/latest/phpmd.phar
install phpmd.phar /usr/bin/phpmd
phpmd --version

wget https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
wget https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar
install phpcs.phar /usr/bin/phpcs
install phpcbf.phar /usr/bin/phpcbf

phpcs --version
phpcbf --version

wget http://static.pdepend.org/php/latest/pdepend.phar
install pdepend.phar /usr/bin/pdepend
pdepend --version
}

main(){
install_plugins
install_php_tools
}

main
