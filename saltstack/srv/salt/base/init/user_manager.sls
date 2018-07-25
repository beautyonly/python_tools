test1:
  user.present:
    - fullname: test1
    - password: '$6$rounds=40000$rWedIkqSCpMrc0ji$Q2xX9rBu60ru8Ivgzu9RPE.A.fJ38y/zhSNZ9KWG4V0O.iMlecJXFWBGIhS4ThRlzBJz3iZQ/jrUQDYFomQHs/'
    - shell: /bin/bash
    - home: /home/test1
    - uid: 600
    - gid: 0
    - group:
      - wheel
      - storage
      - games
