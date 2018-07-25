histroy-init:
  file.append:
    - name: /etc/profile
    - text:
      - export HISTTIMEFORMAT="%F %T `whoami` "
