#!/bin/env bash

install_ruby(){
wget https://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.1.tar.gz
tar -zxf ruby-2.5.1.tar.gz
cd ruby-2.5.1
./configure
make && make install

ruby -v
yum install -y gem openssl openssl-devel zlib zlib-devel

cd ext/zlib
ruby extconf.rb
sed -i 's@$(top_srcdir)@../..@g' Makefile
make && make install
cd -

cd ext/openssl
ruby extconf.rb
sed -i 's@$(top_srcdir)@../..@g' Makefile
make && make install

#gem sources --add http://gems.ruby-china.org/ --remove https://rubygems.org/ # (http)
gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/ # (https)
gem update --system
}

main(){
install_ruby
}

main
