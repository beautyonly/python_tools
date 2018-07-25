#!/bin/env bash

source_install(){
yum install -y gcc gcc-c++ automake autoconf
yum install -y unzip curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker

# wget https://github.com/git/git/archive/git-2.7.4.zip
wget -O git-2.7.4.zip https://codeload.github.com/git/git/zip/v2.7.4
unzip git-2.7.4.zip
cd git-2.7.4

make prefix=/usr/local/git all
make prefix=/usr/local/git install
rm -rf /usr/bin/git
ln -s /usr/local/git/bin/git /usr/bin/git
git --version
}

main(){
source_install
}

main
