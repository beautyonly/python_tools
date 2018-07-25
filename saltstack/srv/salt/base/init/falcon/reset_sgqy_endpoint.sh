sed -i 's/SGQy/SGQY/g' /usr/local/workspace/agent/cfg.json   
sed -i 's/SGQy/SGQY/g' /usr/local/workspace/mymon/etc/mon.cfg
sed -i 's/SGQy/SGQY/g' /etc/salt/minion
/etc/init.d/salt-minion restart
/usr/local/workspace/agent/control restart
