iptables_config(){
iptables -I INPUT -s 123.125.220.50 -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT
/etc/init.d/iptables save

}

monitor_create(){
mysql_cmd='/usr/local/mysql/bin/mysql'
if [ -x '/usr/local/mysql/bin/mysql' ]
then
    ${mysql_cmd} -uroot -p123456 -h127.0.0.1 -e "grant select,super,process,reload,show databases,replication client on *.* to'lepus_monitor'@'%' identified by 'MANAGER';"
    ${mysql_cmd} -uroot -p123456 -h127.0.0.1 -e "flush privileges;"
else
    mysql -uroot -p123456 -h127.0.0.1 -e "grant select,super,process,reload,show databases,replication client on *.* to'lepus_monitor'@'%' identified by 'MANAGER';"
    mysql -uroot -p123456 -h127.0.0.1 -e "flush privileges;"
fi
}

slow_query(){
yum -y install perl-IO-Socket-SSL perl-DBI perl-DBD-MySQL perl-Time-HiRes 'perl(Time::HiRes)'
rpm -ivh https://www.percona.com/downloads/percona-toolkit/2.2.6/RPM/percona-toolkit-2.2.6-1.noarch.rpm
}

snmp_config(){


}

main(){
iptables_config
monitor_create
slow_query
snmp_config
}
