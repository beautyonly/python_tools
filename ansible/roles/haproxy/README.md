# Ansible Role: haproxy

安装haproxy

## 介绍
HAProxy是一种免费的，非常快速和可靠的解决方案，为基于TCP和HTTP的应用程序提供高可用性，负载平衡和代理。

官方网站：http://www.haproxy.org/
官方文档地址：http://cbonte.github.io/haproxy-dconv/
配置文件说明：https://www.haproxy.org/download/1.7/doc/management.txt

## 要求

此角色仅在RHEL及其衍生产品上运行。

## 测试环境

ansible `2.2.1.0`
os `Centos 6.7 X64`

## 角色变量
    software_files_path: "/opt/software"
    software_install_path: "/usr/local"

    haproxy_version: "1.7.5"

    haproxy_file: "haproxy-{{ haproxy_version }}.tar.gz"
    haproxy_file_path: "{{ software_files_path }}/{{ haproxy_file }}"
    haproxy_file_url: "http://www.haproxy.org/download/{{ haproxy_version | splitext | first  }}/src/{{ haproxy_file }}"

    haproxy_user: "haproxy"

    haproxy_chroot: "{{ software_install_path }}/haproxy"
    haproxy_conf_path: "{{ haproxy_chroot }}/conf"
    haproxy_logspath: "/var/log/haproxy"

    haproxy_socket: "/var/run/haproxy.sock"
    haproxy_pid_file: "/var/run/haproxy.pid"

    haproxy_build_target: 'linux26{{ "28"
                             if ( ansible_kernel.split("-")[0] | version_compare("2.6.28",">=", strict=True))
                             else "" }}'
    haproxy_build_arch: "{{ ansible_machine }}"
    haproxy_configure_command: "make TARGET={{ haproxy_build_target }} ARCH={{ haproxy_build_arch }} USE_PCRE=1 USE_OPENSSL=1 USE_ZLIB=1 PREFIX={{ haproxy_chroot }}"

    haproxy_maxconn: 60000
    haproxy_ulimit: 200000
    haproxy_nbproc: "{{ ansible_processor_vcpus | default(ansible_processor_count) }}"

    # Frontend settings.
    haproxy_frontend_name: "hafrontend"
    haproxy_frontend_bind_address: "*"
    haproxy_frontend_port: 80
    haproxy_frontend_mode: "http"
    haproxy_frontend_vars: []
    # haproxy_frontend_vars: |
    #  - 'option httpchk GET /ok.html'
    #  - 'http-check expect status 200'

    # Backend settings.
    haproxy_backend_name: "habackend"
    haproxy_backend_mode: "http"
    haproxy_backend_balance_method: "roundrobin"
    haproxy_backend_httpchk: "HEAD / HTTP/1.1\\r\\nHost:localhost"

    # List of backend servers.
    haproxy_backend_servers: []
    # - name: app1
    #   address: 192.168.0.1:80
    # - name: app2
    #   address: 192.168.0.2:80
    #   check: "inter 5000 rise 2 fall 3"
    #   backup: true
    #   extra: "on-marked-down shutdown-sessions"
      
    haproxy_backend_vars: []
    # haproxy_backend_vars: |
    #  - 'option httpchk GET /ok.html'
    #  - 'http-check expect status 200'

    haproxy_global_vars: []
    # haproxy_global_vars:
    #  - 'ssl-default-bind-ciphers ABCD+KLMJ:...'
    #  - 'ssl-default-bind-options no-sslv3'
          
    haproxy_defaults_vars: []
    # haproxy_defaults_vars: |
    #  - 'timeout client 1m'
    #  - 'timeout server 1m'

    haproxy_conf_extra: ""
    # haproxy_conf_vars: |
    #    frontend mysql
    #        bind *:3306
    #        mode tcp
    #        log global
    #        default_backend mysqlservers

    haproxy_stats: true
    haproxy_stats_bindport: 18080
    haproxy_stats_auth: "admin:admin"
    haproxy_stats_realm: "Haproxy\ Statistics"
    haproxy_stats_allow_src: "{{ ansible_default_ipv4.network }}/{{ ansible_default_ipv4.netmask }}"
    haproxy_stats_uri: "/admin?status"

    ansible_python_interpreter: /usr/bin/python2.6

## 依赖

没有

## github地址
https://github.com/kuailemy123/Ansible-roles/tree/master/haproxy

## Example Playbook
    tcp代理rabbitmq
    - hosts: node2
      vars:
       - haproxy_frontend_port: 55672
       - haproxy_frontend_mode: "tcp"
       - haproxy_frontend_vars:
          - "option tcplog"
       - haproxy_backend_mode: "tcp"
       - haproxy_backend_servers:
           - name: "rabbitmq1"
             address: "192.168.77.129:5672"
           - name: "rabbitmq2"
             address: "192.168.77.130:5672"
           - name: "rabbitmq3"
             address: "192.168.77.131:5672"
      roles:
         - haproxy
         
    http代理rabbitmq
    - hosts: node2
      vars:
       - haproxy_frontend_port: 45672
       - haproxy_backend_servers:
           - name: "rabbitmq1"
             address: "192.168.77.129:15672"
           - name: "rabbitmq2"
             address: "192.168.77.130:15672"
           - name: "rabbitmq3"
             address: "192.168.77.131:15672"
      roles:
        - haproxy

## 使用
/etc/init.d/haproxy
Usage: haproxy {start|stop|restart|reload|condrestart|status|check}
