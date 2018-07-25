apache-install:
  pkg.installed:
    - name: {{ pillar['apache'] }}

apache-service:
  service.running:
    - name: {{ pillar['apache'] }}
    - enable: True
