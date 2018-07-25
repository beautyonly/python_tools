sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum install -y java-1.8.0-openjdk
sudo yum install -y jenkins
sudo service jenkins restart
sleep 10
while [[ ! -f /var/lib/jenkins/config.xml ]]; do sleep 2; done;
sed -i "s@<useSecurity>true<\/useSecurity>@<useSecurity>false<\/useSecurity>@g" /var/lib/jenkins/config.xml
# enable JNLP port, see https://github.com/aespinosa/docker-jenkins/issues/24
sed -i "s@<slaveAgentPort>.*@<slaveAgentPort>49153</slaveAgentPort>@g" /var/lib/jenkins/config.xml
cp /var/lib/jenkins/jenkins.install.UpgradeWizard.state /var/lib/jenkins/jenkins.install.InstallUtil.lastExecVersion
sudo service jenkins restart
sleep 10
while [[ $(curl -s -w "%{http_code}" http://localhost:8080 -o /dev/null) != "200" ]]; do  sleep 5; done;
sudo wget http://localhost:8080/jnlpJars/jenkins-cli.jar
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin git
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin checkstyle
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin workflow-aggregator
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin workflow-api
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin workflow-basic-steps
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin workflow-cps
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin workflow-cps-global-lib
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin workflow-durable-task-step
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin workflow-job
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin workflow-scm-step
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin workflow-step-api
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin workflow-support
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin pipeline-stage-view
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin jquery-detached # pipeline-stage-view dep
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin momentjs # pipeline-stage-view dep
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin handlebars # pipeline-stage-view dep
java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin pipeline-rest-api # pipeline-stage-view dep
sudo service jenkins restart
sleep 10
while [[ $(curl -s -w "%{http_code}" http://localhost:8080 -o /dev/null) != "200" ]]; do  sleep 5; done;
java -jar jenkins-cli.jar -s http://localhost:8080 create-job pipeline < pipeline.xml
