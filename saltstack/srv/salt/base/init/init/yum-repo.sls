yum-repo-epel:
  file.managed:
    - name: /etc/yum.repos.d/epel-{{ grains['osmajorrelease'] }}.repo
    - source: salt://init/init/files/epel-{{ grains['osmajorrelease'] }}.repo
    - user: root
    - group: root
    - mode: 644

yum-repo-cache:
  cmd.run:
    - name: yum makecache
    - require:
      - file: yum-repo-epel
