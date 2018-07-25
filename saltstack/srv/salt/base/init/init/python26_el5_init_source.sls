packages_install:
  pkg.installed:
    - pkgs:
      - gcc
      - gcc-c++
      - automake
      - autoconf
      - python-devel

src_rsync:
  file.recurse:
    - name: /srv/salt/python
    - source: salt://init/python/files
    - user: root
    - group: root
    - makedirs: True
    - include_empty: True
 
python26-install:
    cmd.run:
    - cwd: /srv/salt/python/
    - names:
      - tar zxf Python-2.6.9.tgz
      - cd /srv/salt/python/Python-2.6.9 && ./configure --prefix=/usr/local/python26 && make && make install
    - unless: test -f /usr/local/python26/bin/python
    - require:
      - file: src_rsync

extract_setuptools:
  cmd.run:
    - cwd: /srv/salt/python/
    - names:
      - tar zxf setuptools-28.8.0.tar.gz
      - cd /srv/salt/python/setuptools-28.8.0 && /usr/local/python26/bin/python setup.py install
    - unless: test -f /usr/local/python26/bin/easy_install
    - require:
      - file: src_rsync

extract_pip:
  cmd.run:
    - cwd: /srv/salt/python/
    - names:
      - tar zxf pip-9.0.1.tar.gz
      - cd /srv/salt/python/pip-9.0.1 && /usr/local/python26/bin/python setup.py install
    - unless: test -f /usr/local/python26/bin/pip
    - require:
      - file: src_rsync

virtualenv-install:
  pip.installed:
    - name: virtualenv
    - require:
      - file: src_rsync
      - cmd: extract_pip
    - unless: test -f /usr/local/python26/bin/virtualenv

virtualenv-create:
  cmd.run:
    - name: virtualenv test_env
    - unless: test -d /root/test_env
