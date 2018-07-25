src_rsync:
  file.recurse:
    - name: /srv/salt/elk
    - source: salt://conf/elk
    - user: root
    - group: root
    - makedirs: True
    - include_empty: True
 
extract_filebeat:
  cmd.run:
    - cwd: /srv/salt/elk/
    - names:
      - tar zxvf filebeat-5.1.1-linux-x86_64.tar.gz -C /usr/local/
      - mv /usr/local/filebeat-5.1.1-linux-x86_64 /usr/local/filebeat
    - unless: test -d /usr/local/filebeat
    - require:
      - file: src_rsync

conf_filebeat:
  cmd.run:
    - cwd: /srv/salt/elk/
    - names:
      - cp /srv/salt/elk/filebeat.yml /usr/local/filebeat/
    - require:
      - file: src_rsync

conf_filebeat_log:
  cmd.run:
    - names:
      - mkdir -p /var/log/filebeat
    - unless: test -d /var/log/filebeat

#conf_filebeat_endpoint:
#  cmd.run:
#    - names:
#     - name=`cat /usr/local/workspace/agent/cfg.json |grep hostname |awk -F '\"' '{print $4}'|awk -F '-' '{print $5}'`
#     - tags=`cat /usr/local/workspace/agent/cfg.json |grep hostname |awk -F '\"' '{print $4}'|awk -F '-' '{print $1}'`
#     - sed -i '/^name/{s/\: \"/&'$name'/}' /usr/local/filebeat/filebeat.yml 
#     - sed -i '/^tags/{s/\: \[\"/&'$tags'/}' /usr/local/filebeat/filebeat.yml 

conf_filebeat_start:
  cmd.run:
    - cwd: /srv/salt/elk/
    - names:
      - cp /srv/salt/elk/filebeat /etc/init.d/
      - chmod +x /etc/init.d/filebeat
    - unless: test -f /etc/init.d/filebeat
    - require:
      - file: src_rsync
    
  service.running:
    - name: filebeat
    - enable: True
    - reload: True
    - watch:
      - file: /usr/local/filebeat/filebeat.yml

