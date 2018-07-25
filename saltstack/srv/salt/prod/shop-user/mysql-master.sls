include:
  - modules.mysql.master

master-grant:
  cmd.run:
    - name: mysql -e "GRANT replication slave,super on *.* to 'repl_user'@'192.168.56.0/255.255.255.0' identified by 'repl_user@pass'"
    - unless: mysql -h 192.168.56.11 -u repl_user -prepl_user@pass -e "exit"
