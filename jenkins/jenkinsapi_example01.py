from jenkinsapi.jenkins import Jenkins

J = Jenkins('http://jenkins.xxx.com:8089/jenkins/', 'madongsheng', 'xxxx')
print J.version
for job in J.keys():
    job = J[job]
    print job.get_description()
