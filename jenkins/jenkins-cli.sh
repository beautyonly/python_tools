```
#install jobs
java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job bulk_extractor_disk <forensicator-fate/jenkins/jobs/bulk_extractor_disk.xml

#install views
java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-view "Filesystem Analysis" <forensicator-fate/jenkins/views/FSAnalysis.xml
```
