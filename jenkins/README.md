## 资料
- https://github.com/Neilpang/AutoArchive

### jenkins-pipeline-examples
- https://github.com/kitconcept/jenkins-pipeline-examples
- https://github.com/carlossg/jenkins-swarm-slave-docker
- https://github.com/hibernate/ci.hibernate.org
- https://github.com/maxfields2000/dockerjenkins_tutorial
- https://github.com/GoogleCloudPlatform/kube-jenkins-imager

### 插件
- user build vars
- build-name-setter

### JX
https://github.com/jenkins-x/jx

### API
- 普通触发(建议使用账号名和token,非密码)
```
curl -X POST http://localhost:8080/job/xxx-ci-auto/build --user madongsheng:xxxx
```
- 带参数触发
```
curl -X POST http://localhost:8080/job/xxx-ci-auto/buildWithParameters -d 'branch_name=develop&update_type=update' --user madongsheng:xxxx
```

### 自定义主题
- https://wiki.jenkins.io/display/JENKINS/Simple+Theme+Plugin
- http://afonsof.com/jenkins-material-theme/
