/etc/bashrc:
  file.append:
    - text:
      - export PS1='[\u@\h \w]\$ '
