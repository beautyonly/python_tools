minion_yum:
  file.recurse:
    - name: /etc/yum.repos.d
    - source: salt://conf/yum
    - user: root
    - group: root
    - file_mode: 644
    - dir_mode: 755
    - include_empty: True

minion_install:
  pkg.installed:
    - pkgs:
      - salt-minion
    - require:
      - file: minion_yum
    - unless: rpm -qa | grep salt-minion

minion_conf:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://minions/conf/minion
    -user: root
    - group: root
    - mode: 640
    - template: jinja
    - defaults:
      minion_id: {{ grains['fqdn_ip4'][0]}}
    - require:
      - pkg: minion_install

minion_service:
  service.running:
    - name: salt-minion
    - enable: True
    - require:
      - file: minion_conf
