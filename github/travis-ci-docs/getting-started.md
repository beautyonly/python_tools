# getting-started 入门

# PREREQUISITES 先决条件
开始使用Travis CI之前，请确保拥有以下所有内容：
- GitHub登录
- 项目托管的repo在GitHub上
- 工作代码在你的项目中
- 正在构建或测试脚本


# TO GET STARTED WITH TRAVIS CI 开始使用
- 1、 登录GitHub账号，将Travis CI应用程序添加到你要激活的存储库
- 2、设置仓库激活
- 3、添加配置文件 .travis.yml
- 4、将.travis.yml文件添加到git,提交和推送，以触发Travis CI构建
- 5、根据构建命令的返回状态，通过访问Travis CI.com构建状态并选择您的存储库，检查构建状态页查看构建是否通过或失败

# SELECTING A DIFFERENT PROGRAMMING LANGUAGE 选择不同编程语言
```
# cat .travis.yml
language: php
php:
  - 7.1
service:
  - mysql
before_script:
  - composer install
  - composer dump-autoload
  - cp .env.travis .env
  - php artisan jwt:generate
  - php artisan key:generate
  - php artisan vendor:publish
  - mysql -e 'CREATE DATABASE IF NOT EXISTS jokes ;'
  - php artisan migrate
  - php artisan rsa:generate
script: phpunit


sudo: required
dist: trusty

addons:
   chrome: stable

install:
   - cp .env.testing .env
   - travis_retry composer install --no-interaction --prefer-dist --no-suggest

before_script:
   - google-chrome-stable --headless --disable-gpu --remote-debugging-port=9222 http://localhost &
   - php artisan serve &

script:
   - php artisan dusk
```
# SELECTING INFRASTRUCTURE (OPTIONAL) 选择基础实施(可选)
确定您的构建运行的基础架构的最佳方法是设置language。如果你这样做，你的构建运行在基于Container Based Ubuntu 14.04的默认基础架构上（有一些例外）。您可以通过添加明确选择默认的基础设施sudo: false到你.travis.yml。

- 如果您需要在虚拟机中运行更多可自定义的环境，请使用启用Sudo的基础架构：
``` bash
sudo: enabled
```
- 如果您有需要在macOS上运行的测试，或者您的项目使用Swift或Objective-C，请使用我们的OS X环境：
``` bash
os: osx
```

# MORE THAN RUNNING TESTS 不只是进行测试
Travis CI不仅仅用于运行测试，还有很多其他的事情可以用你的代码来完成：
- 部署到GitHub页面
- 在Heroku上运行应用程序
- 上传RubyGems
- 发送通知

# FURTHER READING 进一步阅读
