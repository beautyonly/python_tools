include:
  - init.init.pkg-base

openldap-install-script:
  file.managed:
    - name: /data0/src/openldap_client.sh
    - source: salt://init/openldap/files/openldap_client.sh
    - user: root
    - group: root
    - mode: 755

openldap-client-install:
  cmd.run:
    - name: sh /data0/src/openldap_client.sh
    - unless:  getent passwd chuanzhen
    - require:
      - file: openldap-install-script

{% if grains['osmajorrelease'] == '6' and grains['os'] == 'CentOS' %}
openldap-nslcd-config:
  file.managed:
    - name: /etc/nslcd.conf
    - source: salt://init/openldap/files/nslcd.conf
    - user: root
    - group: root
    - mode: 600
    - require:
      - file: openldap-install-script
      - cmd: openldap-client-install

openldap-pam_ldap-config:
  file.managed:
    - name: /etc/pam_ldap.conf
    - source: salt://init/openldap/files/pam_ldap.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: openldap-install-script
      - cmd: openldap-client-install

nslcd-service:
  service.running:
    - name: nslcd
    - watch:
      - file: openldap-nslcd-config
    - enable: True
{% endif %}
