include:
  - init.init.yum-repo

python26_install:
  pkg.installed:
    - pkgs:
      - python26
      - python26-crypto
      - python26-pip
      - python26-tools
      - python26-devel

virtualenv-install:
  pip.installed:
    - name: virtualenv
    - unless: test -f python26/bin/virtualenv

virtualenv-create:
  cmd.run:
    - name: virtualenv test_env
    - unless: test -d /root/test_env
