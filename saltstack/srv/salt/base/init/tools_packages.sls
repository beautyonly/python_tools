clean_yum_cache:
    cmd.wait:
        - name: yum clean all

/etc/yum.repos.d/:
  file.recurse:
    - source: salt://conf/yum/
    - user: root
    - group: root
    - file_mode: 644
    - watch_in:
      - cmd: clean_yum_cache

tools_packages:
  pkg:
    - name: tools_packages(yum)
    - pkgs:
      - gcc
      - gcc-c++
      - automake
      - autoconf
      - sshpass
      - ntpd
      - tree
      - lrzsz
      - rsync
      - nmap
      - telnet
      - python-simplejson
      - vim
      - openssl
      - openssl-devel
      - python-devel
    - installed

