> [安全设置](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/secure-settings.html)

elasticsearch提供了一个密钥库和一个elasticsearch-keystore工具来管理密钥库中的设置。

# Creating the keystore
> /usr/share/elasticsearch/bin/elasticsearch-keystore create

文件将被创建在与elasticsearch.yml相同目录下

# Listing settings in the keystore 列出密钥库设置
> /usr/share/elasticsearch/bin/elasticsearch-keystore list

# Adding string settings 添加字符串设置
> /usr/share/elasticsearch/bin/elasticsearch-keystore add the.setting.name.to.set
cat /file/containing/setting/value | /usr/share/elasticsearch/bin/elasticsearch-keystore add --stdin the.setting.name.to.set

# Removing settings 删除设置
> elasticsearch-keystore remove the.setting.name.to.remove
