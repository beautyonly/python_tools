include:
  - modules.keepalived.init

keepalived-server:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://lb-outside/files/haproxy-outside-keepalived.conf
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    {% if grains['fqdn'] == 'linux-node1.example.com' %}
    - ROUTEID: haproxy_ha
    - STATEID: MASTER
    - PRIORITYID: 150
    {% elif grains['fqdn'] == 'linux-node2.example.com' %}
    - ROUTEID: haproxy_ha
    - STATEID: BACKUP
    - PRIORITYID: 100
    {% endif %}

  service.running:
    - name: keepalived
    - enable: True
    - watch:
      - file: keepalived-server
