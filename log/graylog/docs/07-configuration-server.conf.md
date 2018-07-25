# server.conf
官网地址:http://docs.graylog.org/en/latest/pages/configuration/server.conf.html

配置文件的默认地址:http://docs.graylog.org/en/latest/pages/configuration/file_location.html#default-file-location

配置的简单说明
- 每行一个配置项
- 属性和键值之间出现空白将被忽略
- 行首空白也被忽略
- !、#、空行都被忽略
- 属性值后面空白不被忽略，视为属性值的一部分
- 如果每行由\ 字符终止，属性值可以跨越多行
- 字符换行符，回车
- 反斜线字符必须作为双反斜线进行转义

# Properties
## General
- is_master = true
- node_id_file = /etc/graylog/server/<node-id>
- password_secret = <secret>  
> 生成方法：pwgen -N 1 -s 96   
多节点保持一致

- root_username = admin
- root_password_sha2 = <SHA2>
> echo -n yourpassword | shasum -a 256

- root_email = ""
- root_timezone = UTC  
> 需要调整否则日志时间戳不对

- plugin_dir = plugin
- rest_listen_uri = http://127.0.0.1:9000/api/
  - rest api监听地址，运行集群，则所有graylog服务器节点必须可以访问它们
  - 使用graylog收集器时，此url用于接收心跳消息，并且必须可供所有收集器访问
- rest_enable_cors = false
- rest_enable_gzip = false
- rest_enable_tls = true
- rest_tls_cert_file = /path/to/graylog.crt
- rest_tls_key_file = /path/to/graylog.key
- rest_tls_key_password = secret
- rest_max_header_size = 8192
- rest_max_initial_line_length = 4096
- rest_thread_pool_size = 16
- trusted_proxies = 127.0.0.1/32, 0:0:0:0:0:0:0:1/128

## web
- web_enable = true
- web_listen_uri = http://127.0.0.1:9000/
- web_endpoint_uri =
- ......

## Elasticsearch
- elasticsearch_hosts = http://node1:9200,http://user:password@node2:19200
- elasticsearch_connect_timeout = 10s
- elasticsearch_socket_timeout = 60s
- elasticsearch_idle_timeout = -1s
- elasticsearch_max_total_connections = 20
- elasticsearch_max_total_connections_per_route = 2
- elasticsearch_max_retries = 2
- elasticsearch_discovery_enabled = false
- elasticsearch_discovery_filter = rack:42
- elasticsearch_discovery_frequency = 30s
- elasticsearch_compression_enabled = false

## Rotation
- rotation_strategy = count
- elasticsearch_max_docs_per_index = 20000000
- elasticsearch_max_size_per_index = 1073741824
- elasticsearch_max_time_per_index = 1d
- elasticsearch_max_number_of_indices = 20
- retention_strategy = delete
- elasticsearch_disable_version_check = true
- no_retention = false

- elasticsearch_shards = 4
- elasticsearch_replicas = 0
- elasticsearch_index_prefix = graylog
- elasticsearch_template_name = graylog-internal
- elasticsearch_analyzer = standard
- disable_index_optimization = false
- index_optimization_max_num_segments = 1
- allow_leading_wildcard_searches = false
- allow_highlighting = false
> 突出搜索显示

- elasticsearch_request_timeout = 1m
- elasticsearch_index_optimization_timeout = 1h
- elasticsearch_index_optimization_jobs = 20
- index_ranges_cleanup_interval = 1h
- output_batch_size = 500
- output_flush_interval = 1
- output_fault_count_threshold = 5
- output_fault_penalty_seconds = 30
- processbuffer_processors = 5
- outputbuffer_processors = 3
- outputbuffer_processor_keep_alive_time = 5000
- outputbuffer_processor_threads_core_pool_size = 3
- outputbuffer_processor_threads_max_pool_size = 30
- udp_recvbuffer_sizes = 1048576
- processor_wait_strategy = blocking
- ring_size = 65536
- inputbuffer_ring_size = 65536
- inputbuffer_processors = 2
- inputbuffer_wait_strategy = blocking
- message_journal_enabled = true
- message_journal_dir = data/journal
- message_journal_max_age = 12h
- message_journal_max_size = 5gb
- message_journal_flush_age = 1m
- message_journal_flush_interval = 1000000
- message_journal_segment_age = 1h
- message_journal_segment_size = 100mb

- async_eventbus_processors = 2
- lb_recognition_period_seconds = 3
- lb_throttle_threshold_percentage = 95
- stream_processing_timeout = 2000
- stream_processing_max_faults = 3
- alert_check_interval = 60

// 自0.21以来，Graylog服务器支持可插拔输出模块。这意味着一条消息可以写入多个输出。
- output_module_timeout = 10000
- stale_master_timeout = 2000
- shutdown_timeout = 30000

## MongoDB
- mongodb_uri = mongdb://...
  - MongoDB连接字符串。在这里输入您的MongoDB连接和身份验证信息
  - 案例
    - 非认证：mongodb://localhost/graylog
    - 认证：mongodb_uri = mongodb://grayloguser:secret@localhost:27017/graylog
    - 副本集：mongodb://grayloguser:secret@localhost:27017,localhost:27018,localhost:27019/graylog
- mongodb_max_connections = 1000
- mongodb_threads_allowed_to_block_multiplier = 5

## Email
- transport_email_enabled = false
- transport_email_hostname = mail.example.com
- transport_email_port = 587
- transport_email_use_auth = true
- transport_email_use_tls = true
> 使用STARTTLS启用SMTP以进行加密连接。

- transport_email_use_ssl = true
> 启用通过SSL的SMTP（SMTPS）进行加密连接。

- transport_email_auth_username = you@example.com
- transport_email_auth_password = secret
- transport_email_subject_prefix = [graylog]
- transport_email_from_email = graylog@example.com
- transport_email_web_interface_url = https://graylog.example.com
  - 指定此选项可在流警报邮件中包含指向流的链接。
  - 这应该为您的Web界面定义完全合格的基本URL，与您的用户访问它的方式完全相同。

## HTTP
## Others
