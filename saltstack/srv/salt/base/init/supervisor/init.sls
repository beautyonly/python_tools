{%- if grains['os'] == 'Gentoo' %}
  {% set supervisor = 'app-admin/supervisor' %}
{% else %}
  {% set supervisor = 'supervisor' %}
{%- endif %}

supervisor-install:
  pkg.installed:
    - name: {{ supervisor }}

supervisor-modules:
  cmd.run:
    - name: pip install supervisor

supervisor-service:
  service.running:
    - name: supervisord
    - enable: True
