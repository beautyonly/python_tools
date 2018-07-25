base:
    '*':
      - init.env_init
      - init.init-all
    'os:(RedHat|CentOS)':
      - match: grain_pcre
      - repos.epel
      - common.centos
    'os:Ubuntu':
      - common.ubuntu
    'www':
      - nginx
      - php.php-fpm
    'mysql':
      - mysql

prod:
  'linux-node1.example.com':
    - shop-user.mysql-master
    - shop-user.web
    - lb-outside.haproxy-outside-keepalived
    - lb-outside.haproxy-outside

  'linux-node2.example.com':
    - shop-user.mysql-slave
    - shop-user.web
    - lb-outside.haproxy-outside-keepalived
    - lb-outside.haproxy-outside
