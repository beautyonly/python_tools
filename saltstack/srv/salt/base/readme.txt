1、salt-ssh Installs the latest release
https://repo.saltstack.com/#rhel

2、use examples
salt-ssh 'CH-CN-GZ-QCLOUD-xxx' state.sls kaixin.chihuo.chihuo_init
salt 'YTTX-TH*' cp.get_file salt://elk/install_elk_client.sh /tmp/install_elk_client.sh

3、
[root@ansible ~]# curl -sSk https://127.0.0.1:1559/login -H 'Accept:
application/x-yaml' -d username=saltapi -d password=saltapi -d eauth=pam
return:
- eauth: pam
  expire: 1480034523.3140531
  perms:
  - '*':
    - test.*
    - cmd.*
  start: 1479991323.3140521
  token: b61029c756b678e8bf0221eb9c17280850b4838f
  user: saltapi

curl -k https://127.0.0.1:1559/ -H "Accept: application/x-yaml" -H "X-Auth-Token:  b61029c756b678e8bf0221eb9c17280850b4838f" -d client='local' -d tgt='*' -d fun='test.ping'
