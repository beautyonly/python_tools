> http://docs.grafana.org/installation/configuration/

# Configuration
## Comments In .ini Files
; 为注释
## Config file locations
defaults.ini默认配置
custom.ini自定义配置
--config覆盖自定义配置文件路径

## Using environment variables 使用环境变量

## instance_name
## [paths]
  data
  temp_data_lifetime
  logs
  plugins
  provisioning
# [server]
  - http_addr
  - http_port
  ```
  iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 3000
  ```
  protocol
  domain
  enforce_domain
  root_url
  static_root_path
  cert_file
  cert_key
  router_logging
# [database]
  url
  type
  path
  host
  name
  user
  password
  ssl_mode
  ca_cert_path
  client_key_path
  client_cert_path
  server_cert_name
  max_idle_conn
  max_open_conn
  conn_max_lifetime
  log_queries
# [security] 安全
  - admin_user
  默认:admin
  - admin_password
  默认：admin
  login_remember_days
  secret_key
  disable_gravatar
  data_source_proxy_whitelist
# [users]
  allow_sign_up
  allow_org_create
  auto_assign_org
  auto_assign_org_role
  viewers_can_edit
# [auth]
  disable_login_form
  disable_signout_menu
# [auth.anonymous]
  enabled
  org_name
  org_role
# [auth.github]
  team_ids
  allowed_organizations
# [auth.google]
# [auth.generic_oauth]
  Set up oauth2 with Okta
  Set up oauth2 with Bitbucket
  Set up oauth2 with OneLogin
  Set up oauth2 with Auth0
  Set up oauth2 with Azure Active Directory
# [auth.basic]
  enabled
# [auth.ldap]
  enabled
  config_file
  allow_sign_up
# [auth.proxy]
  enabled
  header_name
  header_property
  auto_sign_up
  whitelist
  headers
# [session]
  provider
  provider_config
  cookie_name
  cookie_secure
  session_life_time
# [analytics]
  reporting_enabled
  google_analytics_ua_id
# [dashboards]
  versions_to_keep
# [dashboards.json]
  enabled
  path
# [smtp]
  enabled
  host
  user
  password
  cert_file
  key_file
  skip_verify
  from_address
  from_name
  ehlo_identity
# [log]
  mode
  level
  filters
# [metrics]
  enabled
  interval_seconds
# [metrics.graphite]
  address
  prefix
# [snapshots]
  external_enabled
  external_snapshot_url
  external_snapshot_name
  snapshot_remove_expired
# [external_image_storage]
  provider
# [external_image_storage.s3]
  bucket
  region
  path
  bucket_url
  access_key
  secret_key
# [external_image_storage.webdav]
  url
  public_url
  username
  password
# [external_image_storage.gcs]
  key_file
  bucket name
  path
# [external_image_storage.azure_blob]
  account_name
  account_key
  container_name
# [alerting]
  enabled
  execute_alerts
