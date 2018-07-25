/etc/bashrc:
  file.append:
    - text:
      - export PS1='[\u@\h \w]\$ '
    - unless: grep "export PS1=" /etc/bashrc
