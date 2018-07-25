tty-timeout:
  file.append:
    - name: /etc/profile
    - text:
      - export TMOUT=600
    - unless: grep "export TMOUT=" /etc/profile
