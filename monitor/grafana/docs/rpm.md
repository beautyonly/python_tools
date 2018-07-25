> http://docs.grafana.org/installation/rpm/

# Installing on RPM-based Linux (CentOS, Fedora, OpenSuse, RedHat)
# Install Stable
## On CentOS / Fedora / Redhat:
```
wget https://mirrors.tuna.tsinghua.edu.cn/grafana/yum/el7/grafana-5.2.1-1.x86_64.rpm
yum install initscripts fontconfig
yum install urw-fonts
yum install freetype*
rpm -ivh grafana-5.2.1-1.x86_64.rpm
systemctl daemon-reload
systemctl start grafana-server
systemctl status grafana-server
systemctl enable grafana-server.service
```
## On OpenSuse:
Install via YUM Repository
  RPM GPG Key
Package details
Start the server (init.d service)
Start the server (via systemd)
  Enable the systemd service to start at boot
Environment file
  Logging
  Database
Configuration
  Adding data sources
  Server side image rendering
Installing from binary tar file
