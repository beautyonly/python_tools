> [部署](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/_installation.html)

Elasticsearch 需要java 8,推荐Oracle JDK version 1.8.0_131。[jdk版本在官网](https://docs.oracle.com/javase/8/docs/technotes/guides/install/install_overview.html)查找.

检查版本
```
java -version
echo $JAVA_HOME
```

# Install example with tar
```
curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.9.tar.gz
tar -xvf elasticsearch-5.6.9.tar.gz
cd elasticsearch-5.6.9/bin
./elasticsearch
```

# Install with homebrew
```
brew install elasticsearch
```

# Install example with MSI windows installer
略
