include:
  - init.init.yum-repo

base-install:
  pkg.installed:
    - pkgs:
      - gcc
      - gcc-c++
      - automake
      - autoconf

      - python-devel
      - python-simplejson

      - openssl
      - openssl-devel

      - sshpass
      - ntpdate
      - tree
      - lrzsz
      - rsync
      - nmap
      - telnet
      - screen
      - dos2unix
      - iptraf
      - iftop
      - iotop
      - sysstat
      - wget
      - lsof
      - net-tools
      - mtr
      - unzip
      - zip
      - bind-utils

      - vim-enhanced
    - require:
      - file: /etc/yum.repos.d/epel-{{ grains['osmajorrelease'] }}.repo
