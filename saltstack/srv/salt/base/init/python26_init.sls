packages_install:
  pkg:
    - name: packages_install
    - pkgs:
      - python-devel
    - installed

src_rsync:
  file.recurse:
    - name: /srv/salt/python
    - source: salt://conf/python
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
    - unless: test -d /srv/salt/python/setuptools-28.8.0
    - require:
      - file: src_rsync

extract_pip:
  cmd.run:
    - cwd: /srv/salt/python/
    - names:
      - tar zxf pip-9.0.1.tar.gz
      - cd /srv/salt/python/pip-9.0.1  && python setup.py install
    - unless: test -d /srv/salt/python/pip-9.0.1
    - require:
      - file: src_rsync
