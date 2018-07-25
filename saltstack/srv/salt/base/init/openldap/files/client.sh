sed -i 's@#bind_policy hard@bind_policy soft@g' /etc/pam_ldap.conf
sed -i 's@#timelimit 30@timelimit 5@g' /etc/pam_ldap.conf             
sed -i 's@#bind_timelimit 30@bind_timelimit 5@g' /etc/pam_ldap.conf   
sed -i 's@#idle_timelimit 3600@idle_timelimit 5@g' /etc/pam_ldap.conf 
grep -E "bind_policy|idle_timelimit|timelimit|bind_timelimit" /etc/pam_ldap.conf 

sed -i 's@#timelimit 30@timelimit 5@g' /etc/nslcd.conf            
sed -i 's@#bind_timelimit 30@bind_timelimit 5@g' /etc/nslcd.conf   
sed -i 's@#idle_timelimit 3600@idle_timelimit 5@g' /etc/nslcd.conf
grep -E "bind_policy|idle_timelimit|timelimit|bind_timelimit" /etc/nslcd.conf
/etc/init.d/nslcd restart
