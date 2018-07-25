packages_install:
  pkg.installed:
    - names:
      - python-devel
      - sqlite 
      - sqlite-devel

src_rsync:
  file.recurse:
    - name: /srv/salt/python
    - source: salt://init/init/files/files
    - user: root
    - group: root
    - makedirs: True
    - include_empty: True
 
python27-install:
    cmd.run:
    - cwd: /srv/salt/python/
    - names:
      - tar zxf Python-2.7.12.tgz
      - cd /srv/salt/python/Python-2.7.12 && ./configure --prefix=/usr/local/python27 >/dev/null 2>&1 && make >/dev/null 2>&1 && make install >/dev/null 2>&1
    - unless: test -f /usr/local/python27/bin/python
    - require:
      - file: src_rsync

extract_setuptools:
  cmd.run:
    - cwd: /srv/salt/python/
    - names:
      - tar zxf setuptools-28.8.0.tar.gz
      - cd /srv/salt/python/setuptools-28.8.0 && /usr/local/python27/bin/python setup.py install >/dev/null 2>&1
    - unless: test -f /usr/local/python27/bin/easy_install
    - require:
      - file: src_rsync

extract_pip:
  cmd.run:
    - cwd: /srv/salt/python/
    - names:
      - tar zxf pip-9.0.1.tar.gz
      - cd /srv/salt/python/pip-9.0.1 && /usr/local/python27/bin/python setup.py install >/dev/null 2>&1
    - unless: test -f /usr/local/python27/bin/pip
    - require:
      - file: src_rsync

virtualenv-install:
  cmd.run:
    - name: /usr/local/python27/bin/pip install virtualenv
    - unless: test -f /usr/local/python27/bin/virtualenv
    - require:
      - file: src_rsync
      - cmd: extract_pip

#  pip.installed:
#    - name: virtualenv
#    - require:
#      - file: src_rsync
#      - cmd: extract_pip
#    - unless: test -f /usr/bin/virtualenv

#virtualenv-create:
#  cmd.run:
#    - name: /usr/local/python27/bin/virtualenv test_env
#    - unless: test -d /root/test_env
