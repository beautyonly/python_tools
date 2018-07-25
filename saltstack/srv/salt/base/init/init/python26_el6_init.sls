packages_install:
  pkg.installed:
    - pkgs:
      - python-devel

src_rsync:
  file.recurse:
    - name: /srv/salt/python
    - source: salt://init/python/files
    - user: root
    - group: root
    - makedirs: True
    - include_empty: True
 
extract_setuptools:
  cmd.run:
    - cwd: /srv/salt/python/
    - names:
      - tar zxf setuptools-28.8.0.tar.gz
      - cd /srv/salt/python/setuptools-28.8.0 && python setup.py install
    - unless: test -f /usr/bin/easy_install
    - require:
      - file: src_rsync

extract_pip:
  cmd.run:
    - cwd: /srv/salt/python/
    - names:
      - tar zxf pip-9.0.1.tar.gz
      - cd /srv/salt/python/pip-9.0.1 && python setup.py install
    - unless: test -f /usr/bin/pip
    - require:
      - file: src_rsync

virtualenv-install:
  pip.installed:
    - name: virtualenv
    - require:
      - file: src_rsync
      - cmd: extract_pip
    - unless: test -f /usr/bin/virtualenv

virtualenv-create:
  cmd.run:
    - name: virtualenv test_env
    - unless: test -d /root/test_env
