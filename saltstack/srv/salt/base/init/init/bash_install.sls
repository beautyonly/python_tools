{% if grains['os'] == 'CentOS' and grains['osmajorrelease'] == '6' %}
bash-rpm-file:
  file.managed:
    - name: /data0/src/bash-4.1.2-29.el6.x86_64.rpm
    - source: salt://init/init/files/bash-4.1.2-29.el6.x86_64.rpm
    - user: root
    - group: root
    - mode: 644

bash-rpm-update:
  cmd.run:
    - name: rpm -Uvh --force /data0/src/bash-4.1.2-29.el6.x86_64.rpm
    - unless: rpm -qa bash|grep -q bash-4.1.2-29.el6
    - require: 
      - file: bash-rpm-file
{% endif %}
