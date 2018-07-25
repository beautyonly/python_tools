# mysqlctl总结
## mysqlctl概述
	mysqlctl initializes and controls mysqld with Vitess-specific configuration.

## mysqlctl使用
``` bash
$ ./mysqlctl -h
Usage: ./mysqlctl [global parameters] command [command parameters]

The global optional parameters are:
  -alsologtostderr
        log to standard error as well as files
  -app_idle_timeout duration
        Idle timeout for app connections (default 1m0s)
  -app_pool_size int
        Size of the connection pool for app connections (default 40)
  -backup_storage_compress
        if set, the backup files will be compressed (default is true). Set to false for instance if a backup_storage_hook is specified and it compresses the data. (default true)
  -backup_storage_hook string
        if set, we send the contents of the backup files through this hook.
  -backup_storage_implementation string
        which implementation to use for the backup storage feature
  -cpu_profile string
        write cpu profile to file
  -db-config-dba-charset string
        db dba connection charset
  -db-config-dba-dbname string
        db dba connection dbname
  -db-config-dba-flags uint
        db dba connection flags
  -db-config-dba-host string
        db dba connection host
  -db-config-dba-pass string
        db dba connection pass
  -db-config-dba-port int
        db dba connection port
  -db-config-dba-ssl-ca string
        db dba connection ssl ca
  -db-config-dba-ssl-ca-path string
        db dba connection ssl ca path
  -db-config-dba-ssl-cert string
        db dba connection ssl certificate
  -db-config-dba-ssl-key string
        db dba connection ssl key
  -db-config-dba-uname string
        db dba connection uname
  -db-config-dba-unixsocket string
        db dba connection unix socket
  -db-credentials-file string
        db credentials file
  -db-credentials-server string
        db credentials server type (use 'file' for the file implementation) (default "file")
  -dba_idle_timeout duration
        Idle timeout for dba connections (default 1m0s)
  -dba_pool_size int
        Size of the connection pool for dba connections (default 20)
  -disable_active_reparents
        if set, do not allow active reparents. Use this to protect a cluster using external reparents.
  -emit_stats
        true iff we should emit stats to push-based monitoring/stats backends
  -grpc_auth_mode string
        Which auth plugin implementation to use (eg: static)
  -grpc_auth_static_client_creds string
        when using grpc_static_auth in the server, this file provides the credentials to use to authenticate with server
  -grpc_auth_static_password_file string
        JSON File to read the users/passwords from.
  -grpc_ca string
        ca to use, requires TLS, and enforces client cert check
  -grpc_cert string
        certificate to use, requires grpc_key, enables TLS
  -grpc_compression string
        how to compress gRPC, default: nothing, supported: snappy
  -grpc_enable_tracing
        Enable GRPC tracing
  -grpc_key string
        key to use, requires grpc_cert, enables TLS
  -grpc_max_connection_age duration
        Maximum age of a client connection before GoAway is sent. (default 2562047h47m16.854775807s)
  -grpc_max_connection_age_grace duration
        Additional grace period after grpc_max_connection_age, after which connections are forcibly closed. (default 2562047h47m16.854775807s)
  -grpc_max_message_size int
        Maximum allowed RPC message size. Larger messages will be rejected by gRPC with the error 'exceeding the max size'. (default 4194304)
  -grpc_port int
        Port to listen on for gRPC calls
  -influxdb_database string
        the name of the influxdb database (default "vitess")
  -influxdb_host string
        the influxdb host (with port) (default "localhost:8086")
  -influxdb_password string
        influxdb password (default "root")
  -influxdb_username string
        influxdb username (default "root")
  -keep_logs duration
        keep logs for this long (zero to keep forever)
  -lameduck-period duration
        keep running at least this long after SIGTERM before stopping (default 50ms)
  -log_backtrace_at value
        when logging hits line file:N, emit a stack trace
  -log_dir string
        If non-empty, write log files in this directory
  -logtostderr
        log to standard error instead of files
  -master_connect_retry duration
        how long to wait in between slave -> connection attempts. Only precise to the second. (default 10s)
  -mem-profile-rate int
        profile every n bytes allocated (default 524288)
  -mysql_auth_server_static_file string
        JSON File to read the users/passwords from.
  -mysql_auth_server_static_string string
        JSON representation of the users/passwords config.
  -mysql_port int
        mysql port (default 3306)
  -mysql_socket string
        path to the mysql socket
  -mysqlctl_client_protocol string
        the protocol to use to talk to the mysqlctl server (default "grpc")
  -mysqlctl_mycnf_template string
        template file to use for generating the my.cnf file during server init
  -mysqlctl_socket string
        socket file to use for remote mysqlctl actions (empty for local actions)
  -onterm_timeout duration
        wait no more than this for OnTermSync handlers before stopping (default 10s)
  -pid_file string
        If set, the process will write its pid to the named file, and delete it on graceful shutdown.
  -port int
        vttablet port (default 6612)
  -purge_logs_interval duration
        how often try to remove old logs (default 1h0m0s)
  -security_policy string
        security policy to enforce for URLs
  -service_map value
        comma separated list of services to enable (or disable if prefixed with '-') Example: grpc-vtworker
  -sql-max-length-errors int
        truncate queries in error logs to the given length (default unlimited)
  -sql-max-length-ui int
        truncate queries in debug UIs to the given length (default 512) (default 512)
  -stats_backend string
        The name of the registered push-based monitoring/stats backend to use (default "influxdb")
  -stats_emit_period duration
        Interval between emitting stats to all registered backends (default 1m0s)
  -stderrthreshold value
        logs at or above this threshold go to stderr (default 1)
  -tablet_dir string
        The directory within the vtdataroot to store vttablet/mysql files. Defaults to being generated by the tablet uid.
  -tablet_uid uint
        tablet uid (default 41983)
  -v value
        log level for V logs
  -version
        print binary version
  -vmodule value
        comma-separated list of pattern=N settings for file-filtered logging

The commands are listed below. Use './mysqlctl <command> -h' for more help.

  init [-wait_time=5m] [-init_db_sql_file=]
  init_config
  reinit_config
  teardown [-wait_time=5m] [-force]
  start [-wait_time=5m]
  shutdown [-wait_time=5m]
  position <operation> <pos1> <pos2 | gtid>
```
