include:
  - apache.init
  - php.init
  - mysql.init

extend:
  php-install:
    pkg.installed:
      - pkgs
        - php-tcpdf
        - php-mbstring
